{ pkgs, lib, ... }:

let
  #kloenk_zone =
  #  pkgs.writeText "kloenk.zone" (builtins.readFile (toString ./kloenk.zone));
  bbb_wass_zone =
    pkgs.writeText "bbb.zone" (builtins.readFile (toString ./bbb-wass.zone));
  imkerverein_zone = pkgs.writeText "imkerverein.zone"
    (builtins.readFile (toString ./imkerverein.zone));

  slaves = [
    "159.69.179.160"
    "51.254.249.185"
    "51.254.249.182"
    "216.218.133.2"
    "2001:470:600::2"
    "5.45.100.14"
    "164.132.31.112"
  ];
in {
  imports = [
    (import ../../dns/de.kloenk.nix {
      master = true;
      inherit slaves;
    })
    (import ../../dns/dev.kloenk.nix {
      master = true;
      inherit slaves;
    })
  ];

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.bind = {
    enable = true;
    forwarders = [ "8.8.8.8" ];
    extraOptions = ''
      #response-policy { zone "rpz"; };
    '';
    #  also-notify { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
    #'';

    extraConfig = ''
      statistics-channels {
        inet 127.0.0.1 port 8053;
      };
    '';
    cacheNetworks = [
      "127.0.0.0/24"
      "51.254.249.187/32"
      "195.39.246.48/28"
      "2a0f:4ac0:f199::/48"
    ];

    zones = [
      /* {
              name = "kloenk.de";
              master = true;
              file = kloenk_zone;
              slaves = [
                "159.69.179.160"
                "51.254.249.185"
                "51.254.249.182"
                "216.218.133.2"
                "2001:470:600::2"
                "5.45.100.14"
                "164.132.31.112"
              ];
              #also-notify { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
              #allow-transfer { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
            }
      */
      {
        name = "bbb.wass-er.com";
        master = true;
        file = bbb_wass_zone;
        slaves = [
          "159.69.179.160"
          "51.254.249.185"
          "51.254.249.182"
          "216.218.133.2"
          "2001:470:600::2"
          "5.45.100.14"
          "164.132.31.112"
        ];
        #also-notify { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
        #allow-transfer { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
      }
      {
        name = "burscheider-imkerverein.de";
        master = true;
        file = imkerverein_zone;
        slaves = [
          "159.69.179.160"
          "216.218.133.2"
          "2001:470:600::2"
          "5.45.100.14"
          "164.132.31.112"
        ];
        #also-notify { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
        #allow-transfer { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
      }
      {
        name = "calli0pa.de";
        file = "/persist/data/bind";
        master = false;
        masters = [ "87.79.92.36" ];
      }
      #{
      #  name = "rpz";
      #  master = true;
      #  file = "/etc/nixos/secrets/rpz.zone";
      #}
    ];
  };
}
