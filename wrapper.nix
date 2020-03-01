{ ... }:

{
inherit (import ./default.nix {
    secrets = toString ./../../.password-store;
    #nixpkgs = fetchTarball "https://github.com/nixos/nixpkgs/archive/1caac6f2dc467dd67eff688f3a9befdad5d0f9d0.tar.gz"; # https://github.com/NixOS/nixpkgs/archive/1caac6f2dc467dd67eff688f3a9befdad5d0f9d0.zip
    #nixpkgs = toString ../nixpkgs;
	}) deploy configs tools baseConfig;
}
