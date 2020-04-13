{ config, lib, ... }:

{
  services.ferm2.extraConfig = ''
    table mangle {
      chain PREROUTING {
        mod connmark mark 0 CONNMARK restore-mark;
        interface wg0 MARK set-mark 42;
        CONNMARK save-mark;
      }
      chain OUTPUT {
        CONNMARK restore-mark;
      }
    }
  '';

  systemd.network.netdevs."30-wg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg0";
    };
    wireguardConfig = {
      PrivateKeyFile = config.krops.secrets.files."wg.key".path;
    };
    wireguardPeers = [{
      wireguardPeerConfig = {
        AllowedIPs = [ "0.0.0.0/8" "::/0" ];
        PublicKey = "licaX8d5sOjz7OPZM2YDbEB/PKhwlqoJ3Ut10xfL9Co=";
        PersistentKeepalive = 21;
        Endpoint = "notnetcup.pbb.lc:51820";
      };
    }];
  };
  systemd.network.networks."30-wg0" = {
    name = "wg0";
    addresses = [
      { addressConfig.Address = "195.39.247.10"; }
      { addressConfig.Address = "2a0f:4ac0::10"; }
    ];
    routes = [
      {
        routeConfig.Destination = "0.0.0.0/0";
        routeConfig.Table = "42";
        routeConfig.Source = "195.39.247.10";
      }
      {
        routeConfig.Destination = "::/0";
        routeConfig.Table = "42";
        routeConfig.Source = "2a0f:4ac0::10";
      }
    ];
    extraConfig = ''
      [RoutingPolicyRule]
      FirewallMark = 42
      Table = 42
      Family = both
      Priority = 30000
    '';
  };

  krops.secrets.files."wg.key".owner = "systemd-network";
  users.users.systemd-network.extraGroups = [ "keys" ];
}
