{ nixpkgs, home-manager, nixos-mailserver, jblock, secrets, krops, ... }:

let
  hosts = import ../configuration/hosts;

  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" {};
  
  mkSource = name: host: lib.evalSource [{
    configuration.file = toString ../configuration;
    modules.file = toString ../modules;
    pkgs.file = toString ../pkgs;
    #sources.file = toString ../sources;
    "sources/nixpkgs".file = nixpkgs;
    "sources/home-manager".file = home-manager;
    "sources/nixos-mailserver".file = nixos-mailserver;
    "sources/jblock".file = jblock;
    secrets.pass = {
      dir = secrets;
      inherit name;
    };
    nixos-config.file = toString (pkgs.writeText "nixos-config" ''
      import <configuration/hosts/${name}/configuration.nix>
    '');
    nixpkgs.symlink = "sources/nixpkgs";
  }];
  deploy = lib.mapAttrs (name: host: pkgs.krops.writeDeploy "deploy" {
    source = mkSource name host;
    target = lib.mkTarget host.hostname // {
      sudo = true;
    };
  }) hosts;
in {
  inherit deploy;
}




#  krops = fetchGit {
#    url = "https://github.com/krebs/krops/";
#    ref = "v1.18.1";
#  };
#
#  lib = import "${krops}/lib";
#  pkgs = import "${krops}/pkgs" {};
#
#  mkSource = name: host: lib.evalSource [{
#    configuration.file = toString ../configuration;
#    modules.file = toString ../modules;
#    pkgs.file = toString ../pkgs;
#    sources.file = toString ../sources;
#    secrets.pass = {
#      dir = toString ../secrets;
#      inherit name;
#    };
#    nixos-config.file = toString (pkgs.writeText "nixos-config" ''
#      import <configuration/hosts/${name}/configuration.nix>
#    '');
#    nixpkgs.symlink = "sources/nixpkgs";
#  }];
#in
#  lib.mapAttrs (name: host: pkgs.krops.writeDeploy "deploy" {
#    source = mkSource name host;
#    target = lib.mkTarget host.hostname // {
#      sudo = true;
#    };
#  }) hosts
