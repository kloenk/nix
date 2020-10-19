{ buildGoModule, fetchFromGitHub, stdenv, yarn2nix-moretea, nodejs-slim }:

let
  version = "3.21.0";
  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "sourcegraph";
    rev = "v${version}";
    sha256 = "sha256-hm+TRdZSIJhFDH9yj4+VxBpM5bRzofeSX1y3AK1Fljo=";
  };

  yarn_modules = yarn2nix-moretea.mkYarnPackage { src = "${src}/client/web"; };
in {
  sourcegraph_web = stdenv.mkDerivation {
    name = "sourcgraph_web";
    src = "${src}/client/web";

    preConfigurePhase = ''
      ln -s "${yarn_modules}/webapp/node_modules" "node_modules"
    '';

    buildPhase = ''
      node_modules/.bin/gulp build
    '';
  };

  sourcegraph_go = buildGoModule rec {
    pname = "sourcegraph";

    inherit src version;

    vendorSha256 = "sha256-bUYOKUyDc7QX0g3nDyrzBDeAu3TT+eFCaAsqs/jdRSw=";

    subPackages = [
      "cmd/frontend"
      "cmd/github-proxy"
      "cmd/gitserver"
      "cmd/query-runner"
      "cmd/repo-updater"
      "cmd/searcher"
    ];

  };
}
