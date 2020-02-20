{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.wireguard pkgs.wireguard-tools ];

  networking.firewall = {
    allowedUDPPorts = [
      51820 # wg0
      51821 # wgFam
      51822 # llg0
    ];
  };

  systemd.network.netdevs."30-wg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg0";
    };
    wireguardConfig = {
      FwMark = 51820;
      ListenPort = 51820;
      PrivateKeyFile = config.krops.secrets.files."wg0.key".path;
    };
    wireguardPeers = [
      { # kloenkX
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.42.6/32" "2001:41d0:1004:1629:1337:187:1:6/128" "2a0f:4ac0:f199:42::6/128" ];
          PublicKey = "cTpyxiMfKTdytWMV+lMAUazQPPLAax7rZ98kvPT96no=";
          PresharedKeyFile = config.krops.secrets.files."wg0.kloenkX.psk".path;
          PersistentKeepalive = 21;
        };
      } { # titan
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.42.3/32" "2001:41d0:1004:1629:1337:187:1:3/128" "2a0f:4ac0:f199:42::3/128" ];
          PublicKey = "4SUbImacuAjRwiK/G3CTmczirJQCI20EdJvPwJfCQxQ=";
          PresharedKeyFile = config.krops.secrets.files."wg0.titan.psk".path;
          PersistentKeepalive = 21;
        };
      } { # atom
        wireguardPeerConfig = { 
          AllowedIPs = [ "192.168.42.7/32" "2001:41d0:1004:1629:1337:187:1:7/128" "2a0f:4ac0:f199:42::7/128" ];
          PublicKey = "009Wk3RP7zOmu61Zc7ZCeS6lJyhUcXZwZsBJoadHOA0=";
          PresharedKeyFile = config.krops.secrets.files."wg0.atom.psk".path;
          PersistentKeepalive = 21;
        };
      }
    ];
  };
  systemd.network.networks."30-wg0" = {
    name = "wg0";
    addresses = [
      {
        addressConfig.Address = "192.168.42.1/24";
      }
      {
        addressConfig.Address = "2001:41d0:1004:1629:1337:187:1:0/120";
      }
      {
        addressConfig.Address = "2001:41d0:1004:1629:1337:187:1:1/120";
      }
      {
        addressConfig.Address = "2001:41d0:1004:1629:1337:187:0:1/128";
      }
      {
        addressConfig.Address = "2a0f:4ac0:f199:42::1/64";
      }
    ];
    routes = [
      {
        routeConfig.Destination = "192.168.42.0/24";
        routeConfig.Table = "51820";
      }
      {
        routeConfig.Destination = "2001:41d0:1004:1629:1337:187:1:0/120";
        routeConfig.Table = "51820";
      }
      {
        routeConfig.Destination = "2a0f:4ac0:f199:42::/64";
        routeConfig.Table = "51820";
      }
    ];
    extraConfig = ''
      [RoutingPolicyRule]
      Table = 51820
      Family = both
      Priority = 25000
    '';
  };

  systemd.network.netdevs."30-wgFam" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wgFam";
    };
    wireguardConfig = {
      FwMark = 51820;
      ListenPort = 51821;
      PrivateKeyFile = config.krops.secrets.files."wgFam.key".path;
    };
    wireguardPeers = [
      { # Namu Raspi
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.30.222/32" "2a0f:4ac0:f199:fa14::222/128" ];
           PublicKey = "VUb1id67AUBzA8W4zulMGQMAS8sd1Lk7UbIfZAJWoV4=";
           PresharedKeyFile = config.krops.secrets.files."wgFam.namu.psk".path;
           PersistentKeepalive = 21;
        };
      }  
      { # nein Drachensegler
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.30.3/32" "2a0f:4ac0:f199:fa14::3/128" ];
           PublicKey = "esYAvRGkZ1cRsPoqBVHWjKsKysB7SVv5pNz783k4cXs=";
           #PresharedKeyFile = config.krops.secrets.files."wgFam.namu.psk".path;
           PersistentKeepalive = 21;
        };
      }  
      { # IPhone mum
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.30.212/32" "2a0f:4ac0:f199:fa14::212/128" ];
           PublicKey = "2Yz6+oEqP01haMf9yuh99/Ojt+81CJtLFyr+BPtK+X4=";
           PresharedKeyFile = config.krops.secrets.files."wgFam.imum.psk".path;
           PersistentKeepalive = 21;
        };
      }
    ];
  };
  systemd.network.networks."30-wgFam" = {
    name = "wgFam";
    addresses = [
      { addressConfig.Address = "192.168.30.1/24"; }
      { addressConfig.Address = "2a0f:4ac0:f199:fa14::/64"; }
    ];
    routes = [
      { routeConfig.Destination = "192.168.30.0/24"; routeConfig.Table = "51820"; }
      { routeConfig.Destination = "2a0f:4ac0:f199:fa14::/64"; }
    ];
    extraConfig = ''
      [RoutingPolicyRule]
      Table = 51820
      Family = both
      Priority = 25000
    '';
  };


  systemd.network.netdevs."30-llg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "llg0";
    };
    wireguardConfig = {
      FwMark = 51820;
      ListenPort = 51822;
      PrivateKeyFile = config.krops.secrets.files."llg0.key".path;
    };
    wireguardPeers = [
      { # io
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.43.2/32" "2a0f:4ac0:f199:119::2/128" ];
           PublicKey = "rzyPnz6iliO5hyggfUJcmDrNeFPtMDeWRsq3liEfdQ4=";
           PresharedKeyFile = config.krops.secrets.files."llg0.io.psk".path;
           PersistentKeepalive = 21;
        };
      }  
      { # kloenkX
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.43.10/32" "2a0f:4ac0:f199:199::10/128" ];
           PublicKey = "MYNYNLmxTBsr30JsHV1qSqKqA3Gk54wLaKJn/uwBBiY=";
           #PresharedKeyFile = config.krops.secrets.files."llg0.kloenkX.psk".path;
           PersistentKeepalive = 21;
        };
      }  
      { # phoenix 
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.43.235/32" "2a0f:4ac0:f199:199::235/128" ];
           PublicKey = "IVwWeSQ034oDQytB3IfaxWI5yQcfzz977dN7Ak8nSD8=";
           #PresharedKeyFile = config.krops.secrets.files."wgFam.imum.psk".path;
           PersistentKeepalive = 21;
        };
      }
    ];
  };
  systemd.network.networks."30-llg0" = {
    name = "llg0";
    addresses = [
      { addressConfig.Address = "192.168.43.1/24"; }
      { addressConfig.Address = "2a0f:4ac0:f199:199::/64"; }
    ];
    routes = [
      { routeConfig.Destination = "192.168.43.0/24"; routeConfig.Table = "51820"; }
      { routeConfig.Destination = "2a0f:4ac0:f199:199::/64"; }
    ];
    extraConfig = ''
      [RoutingPolicyRule]
      Table = 51820
      Family = both
      Priority = 25000
    '';
  };

  krops.secrets.files."wg0.key".owner = "systemd-network";
  krops.secrets.files."wg0.titan.psk".owner = "systemd-network";
  krops.secrets.files."wg0.kloenkX.psk".owner = "systemd-network";
  krops.secrets.files."wg0.atom.psk".owner = "systemd-network";
  krops.secrets.files."wgFam.key".owner = "systemd-network";
  krops.secrets.files."wgFam.namu.psk".owner = "systemd-network";
  krops.secrets.files."wgFam.imum.psk".owner = "systemd-network";
  krops.secrets.files."llg0.key".owner = "systemd-network";
  krops.secrets.files."llg0.io.psk".owner = "systemd-network";
  krops.secrets.files."llg0.kloenkX.psk".owner = "systemd-network";
  
  users.users.systemd-network.extraGroups = [ "keys" ];
}
