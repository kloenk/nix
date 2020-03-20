{ nixpkgs, home-manager, nixos-mailserver, ... }@sources:

let
  pkgs = import nixpkgs {};
  lib = pkgs.lib;
  evalConfig = import (nixpkgs + "/nixos/lib/eval-config.nix");

  hosts = import ../hosts;
  nixosHosts = lib.filterAttrs (name: host: host ? hostname) host;
in {
  evals = lib.mapAttrs (name: host: (evalConfig {
    modules = [
      (import ./nixos-config.nix sources).configs.${name}
    ];
  }).config.system.build.toplevel) nixosHosts;
}
