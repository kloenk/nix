#!@shell@
set -e -o pipefail
export PATH=@path@:/run/wrappers/bin/

export PASSWORD_STORE_DIR=${PASSWORD_STORE_DIR:=@secrets@}

read -r hostname < /proc/sys/kernel/hostname
if [[ -z $hostname ]]; then
	hostname="default"
fi

host=$1;
shift || true
[ "$host" == "" ] && host=$hostname

tmpdir=$(mktemp -p /dev/shm -d --suffix nixos-secrets)
trap "rm -rf ${tmpdir};" EXIT
echo "Decrypting secrets"
find "$PASSWORD_STORE_DIR/$host" -type f |
	while read -r gpg_path; do
		rel_name=${gpg_path#$PASSWORD_STORE_DIR}
		rel_name=${rel_name%.gpg}
		mkdir -p "$(dirname "$tmpdir/$rel_name")"
		pass "$rel_name" > "$tmpdir/$rel_name"
	done

echo -n "Deploying secrets to "
if [[ $hostname == $host ]]; then
	echo "localhost"
	sudo rsync -a "$tmpdir/$host/" "/var/src/secrets/" > /dev/null
else
	echo "$host"
	rsync -a "$tmpdir/$host/" -e "ssh $NIX_SSHOPTS" --rsync-path="sudo rsync" "$host:/var/src/secrets/" > /dev/null
fi

