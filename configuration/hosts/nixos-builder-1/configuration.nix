{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    #./wireguard.nix

    ../../default.nix
    ../../common
    #../desktop/spotifyd.nix
    ../../common/collectd.nix

  ];

  environment.variables.NIX_PATH = lib.mkForce "/var/src";

  boot.tmpOnTmpfs = true;

  networking.hostName = "nixos-builder-1";
  networking.extraHosts = ''
    172.16.0.1 airlink.local unit.local
  '';
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];


  systemd.services.collectd.serviceConfig.AmbientCapabilities = [
    "cap_net_raw"
  ];

  # write to collect server
  services.collectd2.plugins = {
    network.options.Server = "51.254.249.187";
    sensors.hasConfig = false;
    processes.hasConfig = false;
    virt.options = {
      Connection = "qemu:///system";
      HostnameFormat = "name";
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.etc.qemu-ifup.source = pkgs.writeText "qemu-ifup" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.iproute}/bin/ip l set dev $1 up
  '';
  environment.etc.qemu-ifdown.source = pkgs.writeText "qemu-ifdown" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.iproute}/bin/ip l set dev $1 down
  '';
  environment.etc.qemu-ifup.mode = "0755";
  environment.etc.qemu-ifdown.mode = "0755";
  security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice_gtk}/bin/spice-client-glib-usb-acl-helper";

  environment.systemPackages = with pkgs; [
  
  ];


  # make autoupdates
  #system.autoUpgrade.enable = true;

  #services.logind.lidSwitch = "ignore";
  users.users.kloenk.initialPassword = "foobaar";
  users.users.kloenk.packages = with pkgs; [
    lm_sensors
    # docker controller
    docker

  ];


  # docker fo
  virtualisation.docker.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
  };

  users.users.kloenk.extraGroups = [
    "docker"   # docker controll group
    "libvirtd" # libvirt group
  ];

  services.udev.packages = [ pkgs.openocd ];

  services.dbus.socketActivated = true;

  # build server
  nix.buildMachines = [
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";
}
