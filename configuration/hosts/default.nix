{ nixos-mailserver ? null }:

let
  pbbAS = { as = 207921; };

  makeHost = { host, port ? 62954, user ? "kloenk", prometheusExporters ? [
    "node-exporter"
    "nginx-exporter"
    "nixos-exporter"
  ], hostname ? "${user}@${host}:${toString port}", ... }@extraArgs:
    ({
      nixos = true;
      system = "x86_64-linux";
    } // extraArgs // {
      host.ip = host;
      host.port = port;
      host.user = user;
      inherit hostname prometheusExporters;
    });

in {
  iluvatar = makeHost {
    host = "iluvatar.kloenk.de";
    vm = true;
    mail = false;
    #wireguard.publicKey = "";
    #wireguard.endpoint = "";
    magicNumber = 252;
  };

  barahir = makeHost {
    host = "192.168.178.95";
    # FIXME: bgp
  };

  thrain = makeHost { host = "192.168.178.248"; };
  eradan = makeHost {
    host = "192.168.178.249";
    vm = true;
    wireguard.publicKey = "x4UDiy+s08NLWKQ2IUizw38qh4PlWSn6tzDh3O4Vh38=";
    #wireguard.endpoint = ""; # FIXME: port forwarding??
  };

  nixos = makeHost {
    host = "192.168.178.0";
    prometheusExporters = [ ];
  };

  sauron = makeHost {
    host = "sauron.kloenk.de";
    vm = true;
  };

  kloenkX = makeHost {
    host = "192.168.178.69";
    #hostname = "kloenk@127.0.0.1:62954";
    #hostname = "kloenk@kloenkX.kloenk.de:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" "wireguard" ];
    wireguard.publicKey = "crMsdERA3xeV8tLpT817R78d4/hGMKS/6LWNyMlsFRQ=";
    magicNumber = 250;
  };
  hubble = makeHost {
    host = "hubble.kloenk.de";
    #prometheusExporters = [ 9100 3001 9090 9154 9187 7980 9586 9119 9166 9113 ];
    prometheusExporters =
      [ "node-exporter" "nginx-exporter" "nixos-exporter" "wireguard" ];
    vm = true;
    mail = true;
    wireguard.publicKey = "2z1soTjkt74lFfEi010JcfOCERhwIgvlqSacOvPYbyI=";
    wireguard.endpoint = "2001:41d0:1004:1629:1337:187::";
    magicNumber = 249;
  };
  #gurke = {
  #  hostname = "gurke.pbb.lc:62954";
  #  prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  #};

  # for monitoring only
  bbb-wass = makeHost {
    host = "bbb-wass.kloenk.de";
    nixos = false;
    user = "root";
    prometheusExporters = [ "node-exporter" "bbb-exporter" ];
  };

  # for monitoring only
  pve-usee = makeHost {
    host = "pve-usee.kloenk.de";
    nixos = false;
    user = "root";
    prometheusExporters = [
      "node-exporter"
      "pve-exporter"
    ]; # https://github.com/znerol/prometheus-pve-exporter
  };

  # for monitoring only
  bbb-usee = makeHost {
    host = "bbb-usee.kloenk.de";
    nixos = false;
    user = "root";
    prometheusExporters = [ "node-exporter" "bbb-exporter" ];
  };

  # for monitoring only
  moodle-usee = makeHost {
    host = "moodle-usee.kloenk.de";
    nixos = false;
    prometheusExporters = [ "node-exporter" ];
  };

  # for monitoring only
  gdv01 = makeHost {
    host = "gdv01.eventphone.de";
    user = "root";
    nixos = false;
    port = 22;
  };
  # for monitoring only
  gdv02 = makeHost {
    host = "gdv02.eventphone.de";
    user = "root";
    nixos = false;
    port = 22;
  };

  # for wireguard only
  combahton = {
    wireguard.publicKey = "9azKCE2ZgWYo0kWD8ezsWDWD3YMlFrxXia23q5ENLm8=";
    wireguard.endpoint = "notcombahton.pbb.lc";
    magicNumber = 5;
    bgp = pbbAS;
  };
  # for wireguard only
  vultr = {
    wireguard.publicKey = "SD8bQrbrr3TlyaUrqZMvlXsrP9GUTYH3wRjAGWVDoTA=";
    wireguard.endpoint = "notvultr.pbb.lc";
    magicNumber = 1;
    bgp = pbbAS;
  };
  # for wireguard only
  tomate = {
    wireguard.publicKey = "bBkntnpzbkN8W0cbJ+yd5MMnPZu7gctQNPGMGMUU23g=";
    magicNumber = 201;
    bgp = pbbAS;
  };
  # for wireguard only
  schinken = {
    wireguard.publicKey = "VT4wAsdBJuFzDhsTgcpdWLMkZJYbfeXa2yAvuGh1/iA=";
    wireguard.endpoint = "2a01:4f8:162:1900::20";
    magicNumber = 4;
    bgp = pbbAS;
  };

  # for dotfiles only
  adminpc = makeHost {
    dotfiles = true;
    nixos = false;
    host = "10.66.6.42";
  };
}
