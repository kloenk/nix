{ config, pkgs, lib, ... }:

{
  systemd.network = {
    networks."20-eno1" = {
      name = "eno1";
      DHCP = "no";
      vlan = lib.singleton "vlan1337";
      addresses = [{ addressConfig.Address = "192.168.178.248/24"; }];
      routes = [
        {
          routeConfig.Gateway = "192.168.178.1";
        }
        {
          routeConfig.Gateway = "fd00::ca0e:14ff:fe07:a2fa";
        }
      ];
    };

    netdevs."25-vlan" = {
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan1337";
      };
      vlanConfig.Id = 1337;
    };
    networks."25-vlan" = {
      name = config.systemd.network.netdevs."25-vlan".netdevConfig.Name;
      DHCP = "no";
      addresses = [
        { addressConfig.Address = "6.0.2.2/24"; }
      ];
    };

    networks."20-lo" = {
      name = "lo";
      DHCP = "no";
      addresses = [
        #{ addressConfig.Address = "195.39.246.53/32"; }
        #{ addressConfig.Address = "2a0f:4ac0:f199::3/128"; }
        { addressConfig.Address = "127.0.0.1/32"; }
        { addressConfig.Address = "::1/128"; }
      ];
    };

    networks."99-how_cares".linkConfig.RequiredForOnline = "no";
    networks."99-how_cares".linkConfig.Unmanaged = "yes";
    networks."99-how_cares".name = "*";
  };
}
