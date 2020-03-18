{ config, pkgs, lib, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
  interface = "enp3s0";
in {
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix

    ../../default.nix
    
    ../../common
    ../../desktop
    ../../desktop/sway.nix

    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  hardware.cpu.intel.updateMicrocode = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5002538e40df324b";
  boot.supportedFilesystems = [ "xfs" "nfs" "ext2" "ext4" ];
  boot.kernelModules = [ "amdgpu" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    wireguard
    acpi_call
  ];

  services.openssh.passwordAuthentication = true;

  boot.initrd.luks.devices."cryptLVM".device = "/dev/disk/by-id/wwn-0x5002538e40df324b-part2";
  boot.initrd.luks.devices."cryptLVM".allowDiscards = true;

  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "radeon.cik_support=0"
    "amdgpu.cik_support=1"
    "radeon.si_support=0"
    "amdgpu.si_support=1"
    "intel_iommu=on"
  ];

  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = false;

  networking.useDHCP = false;
  networking.interfaces."${interface}".useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.hostName = "titan";
  networking.extraHosts = ''
    172.16.0.1 airlink.local unit.local
    192.168.178.248	atom.fritz.box
    127.0.0.1 punkte.kloenk.de
  '';
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.search = [ "fritz.box" "kloenk.de" ];

  # disable firewall
  networking.firewall.enable = false;


  # make autoupdates
  #system.autoUpgrade.enable = true;

  users.users.kloenk.packages = with pkgs; [
    lm_sensors
    wine                   # can we ditch it?
    spotifywm              # spotify fixed for wms
    python                 # includes python2 as dependency for vscode
    platformio             # pio command
    openocd                # pio upload for stlink
    stlink                 # stlink software
    #teamspeak_client       # team speak

    # steam
    steam
    steamcontroller    

    barrier

    minecraft
    multimc
    #ftb

    # docker controller
    docker
    virtmanager
  ];


  # docker fo
  virtualisation.docker.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
  };

  users.users.kloenk.extraGroups = [
    "dialout"  # allowes serial connections
    "plugdev"  # allowes stlink connection
    "docker"   # docker controll group
    "libvirt"
  ];

  services.udev.packages = [ pkgs.openocd ];

  services.pcscd.enable = true;

  hardware.bluetooth.enable = true;

  # add bluetooth sink
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";
  hardware.pulseaudio.zeroconf.discovery.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09";
}
