{ nixpkgs, home-manager, nixos-mailserver, secrets, ... }@sources:

let
  pkgs = import nixpkgs {};
  lib = pkgs.lib;

  hosts = import ../configuration/hosts {};
  nixosHosts = lib.filterAttrs (name: host: host ? hostname) hosts;

  sourcesModule = { lib, ... }: {
    options.sources = lib.mkOption {
    };

    config.sources = sources;
  };
in {
  configs = lib.mapAttrs (name: host:
  { ... }:

    {
      imports = [
        (toString ../configuration + "/hosts/" + name + "/configuration.nix")
        sourcesModule
        (home-manager + "/nixos")
        (toString nixos-mailserver)
        ../modules
      ];
    }
  ) nixosHosts;
}
