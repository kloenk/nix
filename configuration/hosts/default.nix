let

	pbbAS = {
		as = 207921;
	};

in {
	kloenkX = {
		#hostname = "kloenk@127.0.0.1:62954";
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
		hostname = "kloenk@192.168.178.59:62954";
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
	polyus = {
		hostname = "polyus.kloenk.de:62954";
		prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  };
  planets = {
    hostname = "[2001:678:bbc:3e7:f199::1]:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  };

  # for monitoring only
  gdv01 = {
    prometheusExporters = [ "node-exporter" "collectd" ];
  };
  # for monitoring only
  gdv02 = {
    prometheusExporters = [ "node-exporter" "collectd" ];
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
  adminpc = {
    dotfiles = true;
  };
}
