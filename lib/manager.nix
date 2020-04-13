{ nixpkgs, home-manager, secrets, ... }:

let
  sources = { inherit home-manager nixpkgs secrets; };
  pkgs = (import nixpkgs { });
  lib = pkgs.lib;
  hosts = import ../configuration/hosts;
  dotfilesHosts = lib.filterAttrs (name: host: host ? dotfiles) hosts;
  evalConfig = import (home-manager + "/modules");
  evals = lib.mapAttrs (name: host:
    evalConfig {
      configuration =
        (toString ../configuration + "/hosts/" + name + "/home.nix");
      lib = lib;
      pkgs = pkgs;
      check = true;
    }) dotfilesHosts;
in rec {
  home = lib.mapAttrs (name: eval: eval.activationPackage) evals;
  # home = name: (import (home-manager + "/modules") { # use manager for useNixpsgs?
  #   configuration = hm name ;
  #   lib = lib;
  #   pkgs = pkgs;
  #   check = true;
  # });
}
