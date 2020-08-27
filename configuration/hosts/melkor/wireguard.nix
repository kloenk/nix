{ config, lib, ... }:

{
  networking.firewall.allowedUDPPorts = [
    51820 # wg0
  ];

  systemd.network.netdevs."30-wg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg0";
    };
    wireguardConfig = {
      FirewallMark = 51820;
      ListenPort = 51820;
      PrivateKeyFile = config.krops.secrets.files."wg0.key".path;
    };
    wireguardPeers = [{
      wireguardPeerConfig = {
        AllowedIPs = [ "0.0.0.0/0" "::/0" ];
        PublicKey = "MUsPCkTKHBGvCI62CevFs6Wve+cXBLQIl/C3rW3PbVM=";
        PersistentKeepalive = 21;
        Endpoint = "51.254.249.187:51820";
      };
    }];
  };
  systemd.network.networks."30-wg0" = {
    name = "wg0";
    linkConfig = { RequiredForOnline = "no"; };
    addresses = [{ addressConfig.Address = "192.168.42.51/24"; }];
    routes = [
      { routeConfig.Destination = "192.168.42.0/24"; }
      { routeConfig.Destination = "10.0.0.0/24"; }
    ];
  };

  networking.hosts = {
    "10.0.0.2" = [ "io.yougen.de" "git.yougen.de" ];
    "10.0.0.5" = [ "grafana.yougen.de" "hydra.yougen.de" "lycus.yougen.de" ];
  };

  users.users.systemd-network.extraGroups = [ "keys" ];
  krops.secrets.files."wg0.key".owner = "systemd-network";
}
