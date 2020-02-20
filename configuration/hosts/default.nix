let

  pbbAS = {
    as = "207921";
  };

in {
  kloenkX = {
    hostname = "kloenk@kloenkX.kloenk.de:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" "wireguard" ];
    magicNumber = 250;
  };
  hubble = {
    hostname = "kloenk@hubble.kloenk.de:62954";
    #prometheusExporters = [ 9100 3001 9090 9154 9187 7980 9586 9119 9166 9113 ];
    prometheusExporters = [ "node-exporter" "nginx-exporter" "wireguard" ];
    magicNumber = 249;
  };
  titan = {
    #hostname = "kloenk@titan.kloenk.de:62954";
    hostname = "kloenk@192.168.178.171:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" "wireguard" ];
  };
  atom = {
    hostname = "kloenk@192.168.178.248:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" "wireguard" ];
  };
  nixos-builder-1 = {
    hostname = "kloenk@192.168.178.48:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  };
  gurke = {
    hostname = "gurke.pbb.lc:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  };
  # for wireguard only
  combahton = {
    wireguard.publicKey = "9azKCE2ZgWYo0kWD8ezsWDWD3YMlFrxXia23q5ENLm8=";
    wireguard.endpoint = "notcombahton.pbb.lc";
    magicNumber = 5;
    bgp = pbbAS;
  };
  vultr = {
    wireguard.publicKey = "SD8bQrbrr3TlyaUrqZMvlXsrP9GUTYH3wRjAGWVDoTA=";
    wireguard.endpoint = "notvultr.pbb.lc";
    magicNumber = 1;
    bgp = pbbAS;
  };
  netcup = {
    wireguard.publicKey = "licaX8d5sOjz7OPZM2YDbEB/PKhwlqoJ3Ut10xfL9Co=";
    wireguard.endpoint = "notnetcup.pbb.lc";
    magicNumber = 8;
    bgp = pbbAS;
  };
  tomate = {
    wireguard.publicKey = "bBkntnpzbkN8W0cbJ+yd5MMnPZu7gctQNPGMGMUU23g=";
    magicNumber = 201;
    bgp = pbbAS;
  };
  schinken = {
    wireguard.publicKey = "VT4wAsdBJuFzDhsTgcpdWLMkZJYbfeXa2yAvuGh1/iA=";
    wireguard.endpoint = "2a01:4f8:162:1900::20";
    magicNumber = 4;
    bgp = pbbAS;
  };
}
