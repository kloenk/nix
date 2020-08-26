{ master, slaves ? [ ] }:

assert master -> slaves != [ ];

{ inputs, config, lib, ... }:

let
  dns = inputs.dns.lib.${config.nixpkgs.system}.dns;

  mxKloenk = with dns.combinators.mx;
    map (dns.combinators.ttl 3600) [
      (mx 10 "mail.kloenk.de.")
      #secondary (20)
    ];
  dmarc = with dns.combinators;
    [ (txt "v=DMARC1;p=reject;pct=100;rua=mailto:postmaster@kloenk.de") ];
  spfKloenk = with dns.combinators.spf;
    map (dns.combinators.ttl 600) [
      (strict [
        "a:kloenk.de"
        "a:mail.kloenk.de"
        "a:iluvatar.kloenk.de"
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
      nameServer = "ns1.kloenk.de.";
      adminEmail = "hostmaster@kloenk.de";
      serial = 2020081501;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = [ "ns2.he.net." "ns4.he.net." "ns3.he.net." "ns5.he.net." ];

    A = map (ttl 600) [ (a "195.39.247.6") ];

    AAAA = map (ttl 600) [ (aaaa "2a0f:4ac0::6") ];

    MX = mxKloenk;

    TXT = spfKloenk;
    CAA = letsEncrypt config.security.acme.email;

    SRV = [
      {
        service = "minecraft";
        proto = "tcp";
        port = 20023;
        target = "game.00y.de.";
      }
      {
        service = "ts3";
        proto = "udp";
        port = 790;
        target = "web.xorit.de.";
      }
    ];

    subdomains = rec {
      iluvatar = hostTTL 1200 "195.39.247.6" "2a0f:4ac0::6";
      manwe = hostTTL 1200 "195.39.221.187" null;
      sauron = hostTTL 1200 "195.39.221.54" "2a0f:4ac4:42:0:f199::1";
      melkor = hostTTL 1200 "195.39.221.51" null;
      aule = hostTTL 1200 "195.39.221.50" null;

      hubble = hostTTL 600 "51.254.249.187"
        "2001:41d0:1004:1629:1337:0187::"; # TODO: remove

      ns1 = iluvatar;

      _dmarc.TXT = dmarc;

      drachensegler.MX = mxKloenk;
      drachensegler.TXT = spfKloenk;
      drachensegler.subdomains._dmarc.TXT = dmarc;

      ad.MX = mxKloenk;
      ad.TXT = spfKloenk;
      ad.subdomains._dmarc.TXT = dmarc;

      mail = iluvatar;
      bitwarden = iluvatar;
      git = iluvatar;

      grafana = manwe;
      prometheus = manwe;
      alertmanager = manwe;
      #fwd = manwe; # TODO
      #schule = manwe; # TODO
      punkte = manwe;

      hydra = melkor;
      cache = hubble; # TODO: somewhere else

      luna.CNAME = [ "luna.pbb.lc." ];

      bbb-wass.CNAME = [ "bbb.wass-er.com." ];
      moodle-usee.CNAME = [ "segelschule.unterbachersee.de." ];
      bbb-usee.CNAME = [ "schulungsraum.unterbachersee.de." ];
      pve-usee = host "5.9.118.73" "2a01:4f8:162:6343::2";

      source = hostTTL 1200 "195.39.221.186" null; # hosted by y0sh

      gdv01.CNAME = [ "gdv01.eventphone.de." ];
      gdv02.CNAME = [ "gdv02.eventphone.de." ];
      gdvstats.CNAME = [ "gdvstats.eventphone.de." ];
      gdvalerts.CNAME = [ "gdvalerts.eventphone.de." ];

      _github-challenge-cli-inc.TXT = [ (txt "a5adaebc78") ];

      _domainkey.subdomains.mail.TXT = [
        (txt ''
          v=DKIM1; k=rsa; " "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDJ5QgJzy63zC5f7qwHn3sgVrjDLaoLLX3ZnQNbmNms4+OJxNgBlb9uqTNqCEV9ScUX/2V+6IY2TqdhdWaNBif+agsym2UvNbCpvyZt5UFEJsGFoccNLR4iDkBKr8uplaW7GTBf5sUfbPQ2ens7mKvNEa5BMCXQI5oNa1Q6MKLjxwIDAQAB'')
      ];
      ad.subdomains._domainkey.subdomains.mail.TXT = [
        (txt ''
          v=DKIM1; k=rsa; " "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9prC9mhToqsOTwauczmv3hQdsO2n5mE2hJdl8O/VnLxHJV7WZrfyUhT8WO++4jY25e0SJ0Hlv1LFX9WbQMD7oqUIeb5iLzoAAHsPros/obfDqFX7tRMzVKcrOF5zmhV/HD8U/3MRNH2Cj7/tid564qw0i4XuXYgxHl/ow5c7OHwIDAQAB'')
      ];
      drachensegler.subdomains._domainkey.subdomains.mail.TXT = [
        (txt ''
          v=DKIM1; k=rsa; " "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEEgSIeGxjIT5+HqaHlVTt0hL1QPYcidXeJsUgOa1bzfSybD/S0n9tNZidjr+pw2lResdZlyIJ7ozjBMp8MqD0mDDaRwqmy1jTQIFjSDwIORkjRzz4T+m6o3xAcpNrsvfbiOAj02EP5+1OF+0Y6YkdNWeZ2z2/XmL6eoTAYocRuQIDAQAB'')
      ];
    };
  };
in {
  _file = ./de.kloenk.nix;
  services.bind.zones = [{
    name = "kloenk.de";
    inherit master slaves;
    file = dns.writeZone "kloenk.de" zone;
  }];
}
