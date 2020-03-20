#!/usr/bin/env bash


host=$1
mode=$2
shift; shift
args=$@
[ "$host" == "" ] && host="$(hostname)"
[ "$mode" == "" ] && mode="switch"

echo "host: $host"
echo "mode: $mode"
echo "args: $args"

set -e

scratch=$(mktemp -d krops3.XXXXXX)
function finish {
	rm -rf "$scratch"
}
trap finish EXIT

cat >$scratch/nixos-config <<EOL
(import $(pwd)/default.nix {}).configs.${host}
EOL

set -x

nixos-rebuild $mode -I nixos-config=${scratch}/nixos-config $args

set +x
