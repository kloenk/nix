{ stdenv, fetchgit }:

fetchgit (stdenv.lib.importJSON ./source.json)
