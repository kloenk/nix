{ nixpkgs, home-manager, nixos-mailserver, secrets, ... }@sources:

let
  pkgs = import nixpkgs {};
  lib = pkgs.lib;
  evalConfig = import (nixpkgs + "/nixos/lib/eval-config.nix");

  hosts = import ../configuration/hosts;
  nixosHosts = lib.filterAttrs (name: host: host ? hostname) hosts;

  sourcesModule = { lib, ... }: {
    options.sources = lib.mkOption { };
    config.sources = sources;
  };

  evals = lib.mapAttrs (name: host: evalConfig {
    modules = [
      (toString ../configuration + "/hosts/" + name + "/configuration.nix")
      sourcesModule
      (home-manager + "/nixos")
      nixos-mailserver
    ];
    krops.secrets.source-path = toString secrets;
  }) nixosHosts;
  smallConf = evalConfig {
    modules = [
      ../configuration.nix { hydra = true; }
      (home-manager + "/nixos")
      sourcesModule
    ];
  };
in {
  configs = lib.mapAttrs (name: eval: eval.config.system.build.toplevel) evals;
  baseConfig = smallConf;
}
