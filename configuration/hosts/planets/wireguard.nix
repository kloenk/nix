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
    addresses = [
      { addressConfig.Address = "192.168.42.130/32"; }
      { addressConfig.Address = "2a0f:4ac0:f199:42::130/128"; }
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
    ];
  };

  krops.secrets.files."wg0.key".owner = "systemd-network";
}
