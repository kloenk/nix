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
      PrivateKeyFile = config.krops.secrets.files."wg0.key".path;
    };
    wireguardPeers = [{
      wireguardPeerConfig = {
        AllowedIPs = [ "0.0.0.0/0" "::/0" ];
        PublicKey = "UoIRXpG/EHmDNDhzFPxZS18YBlj9vBQRRQZMCFhonDA=";
        PersistentKeepalive = 21;
        Endpoint = "195.39.247.6:51820";
      };
    }];
  };
  systemd.network.networks."30-wg0" = {
    name = "wg0";
    linkConfig = { RequiredForOnline = "yes"; };
    addresses = [{ addressConfig.Address = "192.168.242.52/24"; }];
    routes = [{ routeConfig.Destination = "192.168.242.0/24"; }];
  };

  krops.secrets.files."wg0.key".owner = "systemd-network";
  users.users.systemd-network.extraGroups = [ "keys" ];
}
