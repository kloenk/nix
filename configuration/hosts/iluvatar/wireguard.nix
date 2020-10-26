{ config, lib, ... }:

{
  networking.firewall.allowedUDPPorts = [
    51820 # wg0
    51830 # yougen
  ];

  # NATING
  boot.kernel.sysctl = { "net.ipv4.ip_forward" = 1; };

  #chain POSTROUTING {
  #  outerface enp1s0 SNAT to 195.39.247.6
  #}
  networking.nftables2.extraConfig = ''
    table ip nat {
      chain postrouting {
        type nat hook postrouting priority 100
        ip saddr 192.168.242.0/24 oif wg0 snat 195.39.247.6
        oif enp1s0 masquerade
      }
    }
  '';
  networking.nftables2.forwardPolicy = "accept";

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
      /* {
           wireguardPeerConfig = {
             AllowedIPs = [
               "192.168.42.102/32"
               #"195.39.246.10" # ???
             ];
             PublicKey = "";
             PersistentKeepalive = 21;
           };
         }
      */

      { # bombadil
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.242.52/32" ];
          PublicKey = "zXEZM2MwTNHENXA5aSL5h0mVWvVWxTH3TlKmYoIxzCk=";
        };
      }

      { # thrain
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.242.101/32" ];
          PublicKey = "RiRB/fiZ/x88f78kRQasSwWYBuBjc5DxW2OFaa67zjg=";
          PersistentKeepalive = 21;
        };
      }
      { # barahir
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.242.102/32" ];
          PublicKey = "4SUbImacuAjRwiK/G3CTmczirJQCI20EdJvPwJfCQxQ=";
          PersistentKeepalive = 21;
        };
      }

      { # mi 9 t
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.242.111/32" ];
          PublicKey = "3DpdBLKiw10+nnoh3Fvohdbo4NQDblfGH7WNmk7J7lA=";
          PersistentKeepalive = 21;
        };
      }

      { # Pocophone
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.242.202/32" ];
          PublicKey = "FvBat+gZV47VgiyVRF0QL79rzpk66kQxai0cs9Zvyhw=";
          PersistentKeepalive = 21;
        };
      }
      { # laptop
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.242.203/32" ];
          PublicKey = "HZ4+ZZ7OOJj7cidpUGtvzJEFr9tF3sb8zFDbELjsYjo=";
          PersistentKeepalive = 21;
        };
      }
      { # louwa (luis)
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.242.204/32" ];
          PublicKey = "EAeeDBxci3TAhQExLNU0GzKyhBV30Ku9O1uLKXYzUkU=";
          PersistentKeepalive = 21;
        };
      }
    ];
  };
  systemd.network.networks."30-wg0" = {
    name = "wg0";
    linkConfig = { RequiredForOnline = "no"; };
    addresses = [{ addressConfig.Address = "192.168.242.1/24"; }];
    routes = [{
      routeConfig.Destination = "192.168.242.0/24";
    }
    #{ routeConfig.Destination = "10.0.0.0/24"; }
      ];
  };

  networking.hosts = {
    #"10.0.0.2" = [ "io.yougen.de" "git.yougen.de" ];
    #"10.0.0.5" = [ "grafana.yougen.de" "hydra.yougen.de" "lycus.yougen.de" ];
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
    routes = [{ routeConfig.Destination = "172.16.16.0/24"; }];
  };

  users.users.systemd-network.extraGroups = [ "keys" ];
  krops.secrets.files."wg0.key".owner = "systemd-network";
  krops.secrets.files."yougen.key".owner = "systemd-network";
}
