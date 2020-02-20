{ ... }:

{
  networking.firewall.interfaces."wg0" = {
    allowedTCPPortRanges = [ { from = 1; to = 65534; } ];
    allowedUDPPortRanges = [ { from = 1; to = 65534; } ];
  };

  networking.wireguard.interfaces = { 
    wg0 = {
      ips = [ "192.168.42.3/24" "2001:41d0:1004:1629:1337:187:1:3/120" ];
      privateKeyFile = toString <secrets/wg0.key>;
      peers = [ 
        {
          publicKey = "MUsPCkTKHBGvCI62CevFs6Wve+cXBLQIl/C3rW3PbVM=";
          allowedIPs = [ "192.168.42.0/24" "2001:41d0:1004:1629:1337:187:1:0/120" "2001:41d0:1004:1629:1337:187:0:1/128" ];
          endpoint = "51.254.249.187:51820";
          persistentKeepalive = 21;
          presharedKeyFile = toString <secrets/wg0.psk>;
        }
      ];
    };
  };
}