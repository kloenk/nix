{ config, pkgs, lib, ... }:

{
  systemd.network = {
    networks."20-enp" = {
      name = "enp?s0";
      DHCP = "yes";
    };

    networks."20-lo" = {
      name = "lo";
      DHCP = "no";
      addresses = [
        { addressConfig.Address = "195.39.246.53/32"; }
        { addressConfig.Address = "2a0f:4ac0:f199::3/128"; }
        { addressConfig.Address = "127.0.0.1/32"; }
        { addressConfig.Address = "::1/128"; }
      ];
    };

    networks."99-how_cares".linkConfig.RequiredForOnline = "no";
    networks."99-how_cares".linkConfig.Unmanaged = "yes";
  };
}
