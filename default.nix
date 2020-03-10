{ krops ? fetchTarball "https://github.com/nyantec/krops/archive/master.tar.gz"
, home-manager ? fetchTarball "https://github.com/rycee/home-manager/archive/master.tar.gz"
, nixpkgs ? fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable-small.tar.gz"
, nixos-mailserver ? fetchTarball "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/master/nixos-mailserver-master.tar.gz"
, secrets ? /var/src/secrets
, hydra ? false
}:

let
	sources = {
		inherit krops home-manager nixpkgs nixos-mailserver secrets;
	};
in {
  inherit (import ./lib/nixos-config.nix sources) configs options;
  inherit (import ./lib/manager.nix sources) hm home;
  #sources = inherit (sources);
  jobsets.iso = import ./lib/iso-image.nix sources;
  #pkgs = import ./pkgs sources;
} // (if hydra then {} else {
	inherit (import ./lib/krops.nix sources) deploy;
	tools.kexec_tarball = import ./lib/kexec-tarball.nix sources;
  tools.isoImage = import ./lib/iso-image.nix sources;
  inherit sources;
})

#let
#	hosts = import ./configuration/hosts;
#	pkgs = import ./sources/nixpkgs { };
#in {
#	deploy = import ./lib/krops.nix;
#	kexec_tarball = import ./lib/kexec-tarball.nix;
#	isoImage = import ./lib/iso-image.nix;
#	# pkgs = import ./configuration/pkgs;
#
#	update-sources = pkgs.writeScript "update-sources" ''
#		#!${pkgs.stdenv.shell}
#		set -xe
#		cd ${toString ./.}
#		git submodule foreach git pull
#		git add sources
#		git commit -m "update submodules"
#	'';
#}
