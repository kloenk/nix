{ config, pkgs, lib, ... }:

let
  #secrets = import /etc/nixos/secrets.nix;
in {
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix
    ./bgp.nix
    ./links.nix

    ../../default.nix
    ../../common
    ../../desktop/sway.nix
    ../../desktop
    #../desktop/spotifyd.nix
  ];

  systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

  environment.variables.NIX_PATH = lib.mkForce "/var/src";

  services.logind.lidSwitchDocked = "ignore";

  boot.tmpOnTmpfs = true;

  networking.hostName = "kloenkX";
  networking.useDHCP = false;
  #networking.interfaces.bond0.useDHCP = true;
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp2s0" ];
  networking.wireless.networks = import <secrets/wifi.nix>;
  networking.wireless.userControlled.enable = true;
  networking.extraHosts = ''
    172.16.0.1 airlink.local unit.local
    192.168.42.1 prometheus.kloenk.de alertmanager.kloenk.de
  '';
  networking.nameservers = [ "1.1.1.1" "10.0.0.2" ];

  #networking.bonds."bond0" = {
  #  interfaces = [ "eno0" "wlp2s0" ];
  #};

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  #security.pam.services.xtrlock-pam.fprintAuth = true;

  services.printing.browsing = true;
  services.printing.enable = true;
  services.avahi.enable = true;

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
    spice_gtk
    ebtables
    davfs2
    geogebra
    gtk-engine-murrine
    tango-icon-theme
    breeze-icons
    gnome3.adwaita-icon-theme
  ];

  # make autoupdates
  #system.autoUpgrade.enable = true;

  #services.logind.lidSwitch = "ignore";
  services.tlp.enable = true;
  home-manager.users.kloenk.programs.ssh.matchBlocks.hubble-encrypt.identityFile = toString <secrets/id_rsa>;
  users.users.kloenk.initialPassword = "foobaar";
  users.users.kloenk.packages = with pkgs; [
    lm_sensors
    tpacpi-bat
    acpi                   # fixme: not in the kernel
    wine                   # can we ditch it?
    firefox                # used because of netflix :-(
    spotifywm              # spotify fixed for wms
    python                 # includes python2 as dependency for vscode
    platformio             # pio command
    openocd                # pio upload for stlink
    stlink                 # stlink software
    #teamspeak_client       # team speak

    # steam
    steam
    steamcontroller    

    # minecraft
    multimc

    # docker controller
    docker
    virtmanager

    # paint software
    krita
    sublime3
    wpa_supplicant_gui
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
    "davfs2"   # webdav foo
    "docker"   # docker controll group
    "libvirtd" # libvirt group
  ];

  # ssh key from yg-adminpc
  users.users.kloenk.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhvJ6hdf4pgsFl8c5lMuDAzUVmJwtSY/O66nDDRAK6J kloenk@adminpc" ];

  services.udev.packages = [ pkgs.openocd ];

  services.dbus.socketActivated = true;

  services.pcscd.enable = true;
  #services.pcscd.plugins = with pkgs; [ ccid pcsc-cyberjack ];


  hardware.bluetooth.enable = true;

  # add bluetooth sink
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";
  hardware.pulseaudio.zeroconf.discovery.enable = true;

  # build server
  nix.buildMachines = [
    {
      hostName = "io";
      sshUser = "kloenk";
      sshKey = "/root/.ssh/id_buildfarm";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "big-parallel" ];
      maxJobs = 8;
      speedFactor = 2;
    }
  ];

  services.prometheus.exporters.node.enabledCollectors = [ "tcpstat" "wifi" ];
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";
}
