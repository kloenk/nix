{ pkgs, lib, ... }:

{
  networking.firewall.allowedUDPPorts = [ 67 68 ];

  fileSystems."/var/lib/dhcpd" = {
    device = "/persist/data/dhcpd";
    fsType = "none";
    options = [ "bind" ];
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "eno0" ];
    extraConfig = ''
      default-lease-time 600;
      max-lease-time 7200;
      authoritative;

      subnet 172.16.0.0 netmask 255.255.255.0 {
        range 172.16.0.20 172.16.0.50;
        option routers 172.16.0.1;
      }
    '';
  };

  systemd.services.dhcpd4.wantedBy = lib.mkForce [ ];
}
