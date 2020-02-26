{ ... }:

{
inherit (import ./default.nix {
		secrets = toString ./../../.password-store;
		#nixpkgs = toString ../nixpkgs;
	}) deploy configs;
}
