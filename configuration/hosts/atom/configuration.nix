{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix

    ../../default.nix

    ../../common


    #../../default.nix
    #../users.nix
    #../ssh.nix
    #../collectd.nix

    #../desktop/spotifyd.nix

    #../server/common/nginx-common.nix
    ##../server/home-assistant.nix
    #../server/named-atom.nix

    #./atom.nfs.nix

    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];
  

  networking.hostName = "atom";
  networking.dhcpcd.enable = false;
  networking.interfaces.eno0.ipv4.addresses = [ { address = "192.168.178.248"; prefixLength = 24; } ];
  networking.defaultGateway = "192.168.178.1";
  #networking.interfaces.ens0.ipv6.addresses = [ { address = "2a01:4f8:160:4107::2"; prefixLength = 64; } ];
  #networking.defaultGateway6 = { address = "fe80::1"; interface = "enp4s0"; };
  networking.nameservers = [ "192.168.178.1" "8.8.8.8" ];
  networking.wireless.enable = true;


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

  services.collectd2.plugins = {
    network.options.Server = "51.254.249.187";
    sensors.hasConfig = false;
    processes.hasConfig = false;
  };


  services.prometheus.exporters.fritzbox = {
    enable = true;
    gatewayAddress = "192.168.178.1";
  };

  system.autoUpgrade.enable = true;

  system.stateVersion = "20.03";
}
