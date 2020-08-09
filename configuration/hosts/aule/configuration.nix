{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../default.nix
    ../../common
  ];

  boot.loader.grub.device = "/dev/disk/by-path/pci-0000:05:00.0-scsi-0:1:0:0";
  
  #boot.initrd.postMountC
  networking.hostName = "aule";
  networking.domain = "kloenk.de";
  networking.nameservers = [
    "1.1.1.1"
  ];

  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.ipv4.addresses = [{
    address = "91.240.92.6";
    prefixLength = 32;
  }];

  # default gateway
  systemd.network.networks."40-enp3s0f0" = {
    name = "enp3s0f0";
    routes = [
      {
        routeConfig.Gateway = "91.240.92.1";
        routeConfig.GatewayOnLink = "yes";
      }
    ];
  };

  services.vnstat.enable = true;

  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;

  system.stateVersion = "20.09";
}
