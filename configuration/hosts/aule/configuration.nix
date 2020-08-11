{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../default.nix
    ../../common
    ../../common/y0sh.nix
  ];

  boot.loader.grub.device = "/dev/disk/by-path/pci-0000:05:00.0-scsi-0:1:0:0";

  #boot.initrd.postMountC
  networking.hostName = "aule";
  networking.domain = "kloenk.de";
  networking.nameservers = [ "1.1.1.1" ];

  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.ipv4.addresses = [{
    address = "91.240.92.6";
    prefixLength = 32;
  }];

  networking.bridges.br0.interfaces = [ "enp9s0" ];

  # default gateway
  systemd.network.networks."40-enp3s0f0" = {
    networkConfig.Description = "Network from Kevin";
    name = "enp3s0f0";
    routes = [{
      routeConfig.Gateway = "91.240.92.1";
      routeConfig.GatewayOnLink = "yes";
      routeConfig.Metric = 1024;
    }];
  };

  # y0sh
  /* networking.interfaces.enp9s0.ipv4.address = [{
     address = "192.168.1.98";
     prefixLength = 24;
     }];
  */
  systemd.network.networks."40-enp9s0" = {
    networkConfig.Description = "Glas link to Y0sh";
    name = "enp9s0";
    DHCP = "no";
    addresses = [{ addressConfig.Address = "192.168.1.98/24"; }];
    vlan = [ "as207671" ];
  };

  systemd.network.netdevs."40-as207671" = {
    netdevConfig = {
      Kind = "vlan";
      Name = "as207671";
    };
    vlanConfig.Id = 200;
  };
  systemd.network.networks."40-as207671" = {
    networkConfig.Description = "Y0sh's AS207671";
    name = config.systemd.network.netdevs."40-as207671".netdevConfig.Name;
    DHCP = "no";
    bridge = [ "br0" ];
    /* addresses = [{
         addressConfig.Address = "195.39.221.50/32"; # 50-53; 55-60
       }];
       routes = [{
         routeConfig.Gateway = "195.39.221.1";
         routeConfig.GatewayOnLink = "yes";
         #routeConfig.Metric = "512";
       }];
    */
  };

  systemd.network.networks."40-br0" = {
    name = "br0";
    addresses = [{
      addressConfig.Address = "195.39.221.50/32"; # 50-53; 55-60
    }];
    routes = [{
      routeConfig.Gateway = "195.39.221.1";
      routeConfig.GatewayOnLink = "yes";
      #routeConfig.Metric = "512";
    }];
  };

  virtualisation.libvirtd.enable = true;
  users.users.kloenk.extraGroups = [ "libvirtd" ];

  services.vnstat.enable = true;

  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;

  system.stateVersion = "20.09";
}
