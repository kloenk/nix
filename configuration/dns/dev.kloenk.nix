{ master, slaves ? [ ] }:

assert master -> slaves != [ ];

{ inputs, config, lib, ... }:

let
  dns = inputs.dns.lib.${config.nixpkgs.system}.dns;

  mxKloenk = with dns.combinators.mx;
    map (dns.combinators.ttl 3600) [ (mx 10 "mail.kloenk.dev.") ];
  dmarc = with dns.combinators;
    [ (txt "v=DMARC1;p=reject;pct=100;rua=mailto:postmaster@kloenk.dev") ];
  spfKloenk = with dns.combinators.spf;
    map (dns.combinators.ttl 600) [
      (strict [
        "a:kloenk.dev"
        "a:mail.kloenk.dev"
        "a:iluvatar.kloenk.dev"
        "ip4:195.39.247.6/32"
        "ip6:2a0f:4ac0::6/128"
      ])
    ];

  hostTTL = ttl: ipv4: ipv6:
    lib.optionalAttrs (ipv4 != null) {
      A = [{
        address = ipv4;
        inherit ttl;
      }];
    } // lib.optionalAttrs (ipv6 != null) {
      AAAA = [{
        address = ipv6;
        inherit ttl;
      }];
    };

  zone = with dns.combinators; {
    SOA = ((ttl 600) {
      nameServer = "ns1.kloenk.dev.";
      adminEmail = "hostmaster.kloenk.de."; # TODO: change mail
      serial = 2020102601;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = [ "ns2.he.net." "ns4.he.net." "ns3.he.net." "ns5.he.net." ];

    A = map (ttl 600) [ (a "195.39.247.6") ];

    AAAA = map (ttl 600) [ (aaaa "2a0f:4ac0::6") ];

    TXT = spfKloenk;
    CAA = letsEncrypt config.security.acme.email;

    subdomains = rec {
      iluvatar = hostTTL 1200 "195.39.247.6" "2a0f:4ac0::6";
      manwe = hostTTL 1200 "195.39.221.187" null;
      sauron = hostTTL 1200 "195.39.221.54" "2a0f:4ac4:42:0:f199::1";
      melkor = hostTTL 1200 "195.39.221.51" null;
      bombadil = hostTTL 1200 "195.39.221.52" null;
      aule = hostTTL 1200 "195.39.221.50" null;

      ns1 = iluvatar;

      git = iluvatar;

      lexbeserious = iluvatar;

      _dmarc.TXT = dmarc;

      bitwarden = iluvatar;

      pleroma = manwe;
    };
  };

in {
  _file = ./dev.kloenk.nix;
  services.bind.zones = [{
    name = "kloenk.dev";
    inherit master slaves;
    file = dns.writeZone "kloenk.dev" zone;
  }];
}
