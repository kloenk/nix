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
    #../../desktop/plasma.nix

    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  hardware.cpu.intel.updateMicrocode = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5002538e40df324b";
  boot.supportedFilesystems = [ "xfs" "nfs" "ext2" "ext4" ];
  boot.kernelModules = [ "vfio-pci" "amdgpu" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    wireguard
    acpi_call
  ];

  services.openssh.passwordAuthentication = true;

  boot.initrd.luks.devices."cryptLVM".device = "/dev/disk/by-id/wwn-0x5002538e40df324b-part2";
  boot.initrd.luks.devices."cryptLVM".allowDiscards = true;

  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    #"quiet"
    #"iommu=pt"
    "intel_iommu=on"
    "vfio-pci.ids=1002:699f,1002:aae0"
    "radeon.cik_support=0"
    "amdgpu.cik_support=1"
    "radeon.si_support=0"
    "amdgpu.si_support=1"
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
    qemuVerbatimConfig = ''
      cgroup_device_acl = [
        "/dev/kvm",
        "/dev/input/by-id/usb-STMicroelectronics_obins_anne_keyboard_STM32-if01-event-kbd",
        "/dev/input/by-id/usb-G-Tech_Wireless_Dongle-event-mouse",
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/sev"
      ]
    '';
  };

  users.users.kloenk.extraGroups = [
    "dialout"  # allowes serial connections
    "plugdev"  # allowes stlink connection
    "docker"   # docker controll group
    "libvirtd"
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
