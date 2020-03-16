{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [ wireguard wireguard-tools ];

  networking.firewall.trustedInterfaces = [ "wg0" ];

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
      { addressConfig.Address = "192.168.42.7/32"; }
      { addressConfig.Address = "2a0f:4ac0:f199:42::7/128"; }
      { addressConfig.Address = "2001:41d0:1004:1629:1337:187:1:7/128"; }
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
    extraConfig = ''
      [RoutingPolicyRule]
      Table = 51820
      Family = both
      Priority = 25000
    '';
  };

  krops.secrets.files."wg0.key".owner = "systemd-network";
  krops.secrets.files."wg0.psk".owner = "systemd-network";
  users.users.systemd-network.extraGroups = [ "keys" ];
}
