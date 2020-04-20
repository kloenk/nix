{ pkgs ? import <nixpkgs> {} }:

let
  lib = pkgs.lib;
  recurse = with lib; prefix: item:
    if item ? outPath then
      item.outPath
    else if isAttrs item then
      map (name: recurse (prefix + "." + name) item.${name}) (attrNames item)
    else if isList item then
      imap0 (index: item: recurse (prefix + "[${toString index}]") item) item
    else
      [];
  attrs = pkgs.callPackage ./wallpapers.nix { };
  list = lib.flatten (recurse "" attrs);
in pkgs.runCommand "wallpapers-merged" {} ''
  mkdir -p $out/share/wallpapers/
  ${lib.concatStringsSep "\n" (map (e: ''
    ln -s ${e} $out/share/wallpapers/
  '') list)}
''
