{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix

    ../../default.nix

    ../../common


    #../users.nix
    #../ssh.nix

    #../desktop/spotifyd.nix

    #../server/common/nginx-common.nix
    ##../server/home-assistant.nix
    #../server/named-atom.nix

    #./atom.nfs.nix

    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  hardware.cpu.intel.updateMicrocode = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-HTS721010G9SA00_MPDZN7Y0J7WN6L";
  boot.supportedFilesystems = [ "ext2" "xfs" "nfs" "ext4" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.wireguard
  ];

  networking.hostName = "atom";
  networking.useDHCP = false;

  systemd.network.networks."20-en" = {
    name = "en*";
    addresses = [
      { addressConfig.Address = "192.168.178.248/24"; }
      { addressConfig.Address = "2a0a:a541:35a:0::248/64"; }
    ];
    routes = [
      {
        routeConfig.Destination = "192.168.178.0/24";
      }
      {
        routeConfig.Destination = "2a0a:a541:35a:0::248/64";
      }
      {
        routeConfig.Gateway = "192.168.178.1";
      }
      {
        routeConfig.Gateway = "fe80::ca0e:14ff:fe07:a2fa";
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 4317 3702 ];
  networking.firewall.allowedUDPPorts = [ 3702 ];

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    systemWide = true;
    package = pkgs.pulseaudio;
    tcp.enable = true;
    tcp.anonymousClients.allowAll = true;
    zeroconf.publish.enable = true;
  };

  services.vnstat.enable = true;

  services.prometheus.exporters.fritzbox = {
    enable = true;
    gatewayAddress = "192.168.178.1";
  };

  system.autoUpgrade.enable = true;

  system.stateVersion = "20.09";
}
