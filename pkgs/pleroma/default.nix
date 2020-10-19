{ lib, mixnix, callPackage, beamPackages, fetchpatch, git, cmake }:

mixnix.mkPureMixPackage rec {
  name = "pleroma";
  inherit (callPackage ./source.nix { }) src version;

  beamDeps = [
    (beamPackages.buildMix {
      name = "restarter";
      version = "0.1.0";
      src = src + "/restarter";
    })
  ];

  importedMixNix =
    let deps = lib.filterAttrs (k: v: k != "nodex") (import ./mix.nix);
    in deps // {
      websocket_client = deps.websocket_client // { builder = "rebar3"; };
      crypt = deps.crypt // { builder = "rebar3"; };
      gun = deps.gun // {
        builder = "rebar3";
        deps = [ "cowlib" ];
      };
    };

  mixConfig = {
    gun = { ... }: { patches = [ ./gun.patch ]; };
    fast_html = { ... }: { nativeBuildInputs = [ cmake ]; };
    syslog = { ... }: {
      patches = [ ./syslog.patch ];
      buildPlugins = [ beamPackages.pc ];
    };
  };

  buildInputs = [ git ];
  preBuild = "echo 'import Mix.Config' > config/prod.secret.exs";
  postBuild = "mix release --path $out --no-deps-check";
}
