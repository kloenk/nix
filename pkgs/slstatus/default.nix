{ callPackage, fetchFromGitHub, lib, rwm }:

callPackage (fetchFromGitHub (lib.importJSON ./source.json)) { }
