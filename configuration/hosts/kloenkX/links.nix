{ config, pgks, lib, ... }:

let
  bondName = "world";
in {
  systemd.network = {
    #netdevs."30-bond0" = {
    #  netdevConfig = {
    #    Kind = "bond";
    #    Name = bondName;
    #  };
    #  bondConfig = {
    #    Mode = "active-backup";
    #    MinLinks = "1";
    #    FailOverMACPolicy = "active";
    #  };
    #};
    #networks."50-bond0" = {
    #  name = bondName;
    #  DHCP = "yes";
    #};
    #networks."30-bond0" = {
    #  name = bondName;
    #  DHCP = "yes";
    #  matchConfig.SSID = "TT-WLAN";
    #};
    

    networks."20-eno0" = {
      name = "eno0";
      DHCP = "yes";
    };
    networks."20-wlp2s0" = {
      name = "wlp2s0";
      DHCP = "yes";
    };
    networks."30-lo" = {
      name = "lo";
      DHCP = "no";
      addresses = [
        { addressConfig.Address = "195.39.246.50/32"; }
        { addressConfig.Address = "2a0f:4ac0:f199::6/128"; }
        { addressConfig.Address = "127.0.0.1"; }
        { addressConfig.Address = "127.0.0.53"; }
        { addressConfig.Address = "::1/128"; }
      ];
    };
    networks."99-how_cares".linkConfig.RequiredForOnline = "no";
    networks."99-how_cares".linkConfig.Unmanaged = "yes";
  };
}
