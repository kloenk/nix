{ system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; }, ... }:

let
  lib = pkgs.lib;
  callPackage = lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
    collectd-wireguard = callPackage ./collectd-wireguard { };
    engelsystem = callPackage ./engelsystem { };
    #rifo = callPackage ./rifo { };
    rwm = callPackage ./rwm { };
    dwm = callPackage ./dwm { rwm = newpkgs.rwm; };
    slstatus = callPackage ./slstatus { };
    ftb = callPackage ./ftb { libXxf86vm = pkgs.xorg.libXxf86vm; };
    #flameshot = pkgs.libsForQt5.callPackage ./flameshot { };
    #llgCompanion = callPackage ./llgCompanion { };
    shelfie = callPackage ./shelfie { };
    pytradfri = callPackage ./pytradfri { buildPythonPackage = pkgs.python37Packages.buildPythonPackage; fetchPypi = pkgs.python37Packages.fetchPypi; cython = pkgs.python37Packages.cython; };
    aiocoap = callPackage ./aiocoap { buildPythonPackage = pkgs.python37Packages.buildPythonPackage; fetchPypi = pkgs.python37Packages.fetchPypi; cython = pkgs.python37Packages.cython; };
    inherit (callPackage ./minecraft-server { })
      minecraft-server_1_14_2;
  };

in newpkgs
