{ callPackage, fetchFromGitHub, lib }:

callPackage (fetchFromGitHub (lib.importJSON ./source.json)) {}
