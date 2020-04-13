{ nixpkgs, krops3, home-manager, nixos-mailserver, ... }@sources:

let
  pkgs = import nixpkgs { };
  lib = pkgs.lib;

  kropsPkgs = import "${krops3}/pkgs" { };

  sourcesModule = pkgs.writeText "soures-module" ''
    { lib, ... }:
    {
      options.sources = lib.mkOption {
      };

      config.sources = {
        ${
          lib.concatStringsSep "\n"
          (lib.mapAttrsToList (name: source: "${name} = ${source};") sources)
        }
      };
    }
  '';

  hosts =
    import ../configuration/hosts { nixos-mailserver = nixos-mailserver; };
  nixosHosts = lib.filterAttrs (name: host: host ? hostname) hosts;

in {
  deploy = lib.mapAttrs (name: host:
    kropsPkgs.krops3.writeDeploy name {
      buildTarget = "localhost:62954";
      # useHostNixpkgs = true;
      extraSources = [ (home-manager + "/nixos") ../modules sourcesModule (nixpkgs + "/nixos/modules/installer/scan/not-deteced.nix") ]
        ++ (if host ? extraSources then host.extraSources else [ ]);
      sudo = true;
      configuration = (toString ../configuration)
        + "/hosts/${name}/configuration.nix";
      target = host.hostname;
    }) nixosHosts;
}
