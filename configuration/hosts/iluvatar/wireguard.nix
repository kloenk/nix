{ config, lib, ... }:

{
  networking.firewall.allowedUDPPorts = [
    51820 # wg0
    51830 # yougen
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
    wireguardPeers = [
      {
      wireguardPeerConfig = {
        AllowedIPs = [
          "192.168.42.0/26"
          #"0.0.0.0/0"
          #"::/0"
        };
        PublicKey = "MUsPCkTKHBGvCI62CevFs6Wve+cXBLQIl/C3rW3PbVM=";
        PersistentKeepalive = 21;
        Endpoint = "51.254.249.187:51820";
      };
    }
    {
      wireguardPeerConfig = {
        AllowedIPs = [
          "192.168.42.102/32"
          #"195.39.246.10" # ???
        ];
        PublicKey = "";
        PersistentKeepalive = 21;
      };
    }
  ];
  };
  systemd.network.networks."30-wg0" = {
    name = "wg0";
    linkConfig = { RequiredForOnline = "no"; };
    addresses = [{ addressConfig.Address = "192.168.42.50/24"; }];
    routes = [
      { routeConfig.Destination = "192.168.42.0/24"; }
      { routeConfig.Destination = "10.0.0.0/24"; }
    ];
  };

  networking.hosts = {
    "10.0.0.2" = [ "io.yougen.de" "git.yougen.de" ];
    "10.0.0.5" = [ "grafana.yougen.de" "hydra.yougen.de" "lycus.yougen.de" ];
    "172.16.16.3" = [ "core.josefstrasse.yougen.de" ];
  };

  systemd.network.netdevs."30-yougen" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "yougen";
    };
    wireguardConfig = {
      FirewallMark = 51820;
      ListenPort = 51830;
      PrivateKeyFile = config.krops.secrets.files."yougen.key".path;
    };
    wireguardPeers = [{
      wireguardPeerConfig = {
        AllowedIPs = [ "172.16.16.3/32" ];
        PublicKey = "UDdUoBRXy+3skbUuh7gLNmHnnbtJPncbCPPeZNX/rBU=";
        PersistentKeepalive = 21;
      };
    }];
  };
  systemd.network.networks."30-yougen" = {
    name = "yougen";
    linkConfig.RequiredForOnline = "no";
    addresses = [{ addressConfig.Address = "172.16.16.1/24"; }];
    routes = [
      { routeConfig.Destination = "172.16.16.0/24"; }
    ];
  };

  users.users.systemd-network.extraGroups = [ "keys" ];
  krops.secrets.files."wg0.key".owner = "systemd-network";
  krops.secrets.files."yougen.key".owner = "systemd-network";
}
