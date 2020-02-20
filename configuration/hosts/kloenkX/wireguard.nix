{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [ wireguard wireguard-tools ];
 
  systemd.network.netdevs."30-wg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg0";
    };
    wireguardConfig = {
      FwMark = 51820;
      PrivateKeyFile = config.krops.secrets.files."wg0.key".path;
    };
    wireguardPeers = [
      { wireguardPeerConfig = {
        AllowedIPs = [ "0.0.0.0/0" "::/0" ];
        PublicKey = "MUsPCkTKHBGvCI62CevFs6Wve+cXBLQIl/C3rW3PbVM=";
        PresharedKeyFile = config.krops.secrets.files."wg0.psk".path;
        PersistentKeepalive = 21;
        Endpoint = "51.254.249.187:51820";
      }; }
    ];
  };
  systemd.network.networks."30-wg0" = {
    name = "wg0";
    addresses = [
      { addressConfig.Address = "192.168.42.6/32"; }
      { addressConfig.Address = "2a0f:4ac0:f199:42::6/128"; }
      { addressConfig.Address = "2001:41d0:1004:1629:1337:187:1:6/128"; } # legacy
    ];
    routes = [
      {
        routeConfig.Destination = "192.168.42.0/24";
        routeConfig.Table = "51820";
      }
      {
        routeConfig.Destination = "2a0f:4ac0:f199:42::/64";
        routeConfig.Table = "51820";
      }
      {
        routeConfig.Destination = "2001:41d0:1004:1629:1337:187:1:0/120";
        routeConfig.Table = "51820";
      }
    ];
  };

  krops.secrets.files."wg0.key".owner = "systemd-network";
  krops.secrets.files."wg0.psk".owner = "systemd-network";
  
  users.users.systemd-network.extraGroups = [ "keys" ];

  networking.wireguard.interfaces = {
    llg0 = {
      ips = [ "192.168.43.10" "2001:41d0:1004:1629:1337:187:43:10/120" ];
      privateKeyFile = toString <secrets/llg0.key>;
      peers = [ {
        publicKey = "Ll0Zb5I3L8H4WCzowkh13REiXcxmoTgSKi01NrzKiCM=";
        allowedIPs = [ "192.168.43.0/24" "2001:41d0:1004:1629:1337:187:43:0/120" "10.0.0.0/8" ];
        endpoint = "51.254.249.187:51822";
        persistentKeepalive = 21;
        presharedKeyFile = toString <secrets/llg0.psk>;
      } ];

      allowedIPsAsRoutes = false;
      postSetup = ''
        ip route add 192.168.43.0/24 dev llg0 metric 2048
        ip -6 route add 2001:41d0:1004:1629:1337:187:43:0/120 dev llg0 # no metric, ipv6
        ip route add 10.0.0.0/8 dev llg0 metric 2048
      '';
    };
  };
}
