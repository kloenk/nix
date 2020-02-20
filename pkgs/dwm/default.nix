{ callPackage, fetchFromGitHub, lib, rwm, pkgs }:

callPackage (fetchFromGitHub (lib.importJSON ./source.json)) { rwm = rwm; terminal = "${pkgs.kitty}/bin/kitty"; stdenv = pkgs.clangStdenv; }
