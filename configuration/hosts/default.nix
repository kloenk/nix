{ nixos-mailserver ? null }:

let
  pbbAS = { as = 207921; };

  makeHost = { host, port ? 62954, user ? "kloenk", prometheusExporters ? [
    "node-exporter"
    "nginx-exporter"
    #"nixos-exporter"
  ], hostname ? "${user}@${host}:${toString port}", server ? false, ...
    }@extraArgs:
    ({
      nixos = true;
      system = "x86_64-linux";
    } // extraArgs // {
      host.ip = host;
      host.port = port;
      host.user = user;
      inherit hostname prometheusExporters server;
    });

in {
  iluvatar = makeHost {
    host = "iluvatar.kloenk.de";
    vm = true;
    mail = true;
    #wireguard.publicKey = "";
    #wireguard.endpoint = "";
    magicNumber = 252;
    server = true;
  };

  manwe = makeHost {
    host = "manwe.kloenk.de";
    vm = true;
    #mail = true;
    server = true;
  };

  aule = makeHost {
    host = "aule.kloenk.de"; # 195.39.221.50
    server = true;
  };

  melkor = makeHost {
    host = "melkor.kloenk.de";
    vm = true;
    server = true;
  };

  bombadil = makeHost {
    host = "195.39.221.52";
    server = true;
    vm = true;
  };

  barahir = makeHost {
    host = "192.168.178.95";
    # FIXME: bgp
  };

  thrain = makeHost {
    host = "192.168.178.248";
    # server = true;
  };
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
    server = true;
  };

  samwise = makeHost { host = "6.0.2.4"; };

  robotnix = makeHost { host = "195.39.221.59"; };

  # https://lotr.fandom.com/wiki/V%C3%ABantur
  veantur = makeHost {
    system = "aarch64-linux";
    host = "192.168.42.101";
    prometheusExporters = [ ];
  };

  # for monitoring only
  bbb-wass = makeHost {
    host = "bbb-wass.kloenk.de";
    nixos = false;
    user = "root";
    prometheusExporters = [ "node-exporter" "bbb-exporter" ];
    #server = true;
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
    server = true;
  };

  # for monitoring only
  bbb-usee = makeHost {
    host = "bbb-usee.kloenk.de";
    nixos = false;
    user = "root";
    prometheusExporters = [ "node-exporter" "bbb-exporter" ];
    server = true;
  };

  # for monitoring only
  moodle-usee = makeHost {
    host = "moodle-usee.kloenk.de";
    nixos = false;
    prometheusExporters = [ "node-exporter" ];
    server = true;
  };

  # for wireguard only
  /* combahton = {
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
  */
}
