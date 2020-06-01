{ lib, pkgs, configurations, ... }:

let

in {
  deploy = pkgs.writeShellScript "deploy.sh" ''
    #!${pkgs.bash}/bin/bash

    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (host: script: ''
      ${pkgs.nix}/bin/nix copy --no-check-sigs --to ssh://host ${script.config.system.build.toplevel} -s # toggle -s
    '') configurations)}
  '';
}
