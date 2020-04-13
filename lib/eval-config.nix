{ nixpkgs, home-manager, nixos-mailserver, ... }@sources:

let
  pkgs = import nixpkgs { };
  lib = pkgs.lib;
  evalConfig = import (nixpkgs + "/nixos/lib/eval-config.nix");

  hosts = import ../configuration/hosts { };
  nixosHosts = lib.filterAttrs (name: host: host ? hostname) hosts;
in {
  evals = lib.mapAttrs (name: host:
    (evalConfig {
      modules = [ (import ./nixos-config.nix sources).configs.${name} ];
    })) nixosHosts;
}
