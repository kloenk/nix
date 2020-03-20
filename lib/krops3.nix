{ nixpkgs, krops, ... }:

let
  pkgs = import nixpkgs {};
  lib = pkgs.lib;

  kropsLib = import "${krops}/lib";

  hosts = import ../configuration/hosts;
  nixosHosts = lib.filterAttrs (name: host: host ? hostname) hosts;

  nixos-config = name: pkgs.writeText "nixos-config.${name}" ''
    (import ${kropsLib.getEnv "PWD"}/wrapper.nix {}).configs.${name}
  '';

  targetHost = host: kropsLib.mkTarget host;
in {
  deploy = lib.mapAttrs (name: host:
    pkgs.writeScript "krops3-${name}.sh" ''
      #!${pkgs.bash}/bin/bash

      mode=$1
      shift
      args=$@

      [ "$mode" == "" ] && mode="switch"

      set -ex

      ${if kropsLib.getHostName == name then ''
        nixos-rebuild $mode -I nixos-config=${nixos-config name} --use-remote-sudo $args
      '' else ''
        NIX_SSHOPTS="-p${(targetHost host.hostname).port} $NIX_SSHOPTS"
        export NIX_SSHOPTS
        nixos-rebuild $mode -I nixos-config=${nixos-config name} --use-remote-sudo --target-host ${(targetHost host.hostname).host}  $args
      ''}

      cat ${nixos-config name}

      echo ${if kropsLib.getHostName == name then "local" else "remote"}
    ''
  ) nixosHosts;
}
