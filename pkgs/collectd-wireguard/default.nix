{
  stdenv
, fetchFromGitHub
, lib
, bash
, coreutils
, wireguard-tools
}:

with lib;

 let
  dependencies = [
    bash
    coreutils
    wireguard-tools
  ];

 in stdenv.mkDerivation {
  name = "collectd-wireguard";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "snh";
    repo = "collectd-wireguard";
    rev = "v1.0.2";
    sha256 = "0yp0iff17500wqxw8p95nw67zyvbpr946crmmk98ggsi5dnhx5x3";
  };

  installPhase = ''
    mkdir -p $out/bin
    sed -i "s+wg+${wireguard-tools}/bin/wg+g" collectd-wireguard.sh
    sed -i "s+/bin/bash+${bash}/bin/bash+g" collectd-wireguard.sh
    sed -i 's+"sudo"+/run/wrappers/bin/sudo+g' collectd-wireguard.sh
    install -Dm0755 collectd-wireguard.sh $out/bin/collectd-wireguard
  '';

  meta = {
    license = licenses.mit;
  };
}
