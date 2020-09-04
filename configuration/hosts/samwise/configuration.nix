{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./links.nix
    ./mysql.nix
    ./dhcpcd.nix

    ../../default.nix
    ../../common
    ../../common/pbb.nix
    ../../common/syncthing.nix
    ../../desktop
    ../../desktop/sway.nix
    ../../desktop/vscode.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.logind.lidSwitchDocked = "ignore";

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  boot.supportedFilesystems = [ "xfs" "vfat" ];
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.initrd.availableKernelModules = [ "i915" ];
  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices."cryptRoot".device =
    "/dev/disk/by-uuid/07e84a85-0386-4696-b8ea-a7c82cfd275d";
  boot.initrd.luks.devices."cryptRoot".allowDiscards = true;

  systemd.services.coreboot-battery-treshold = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ ectool ];
    script = ''
      ectool -w 0xb0 -z 0x46
      ectool -w 0xb1 -z 0x5a
    '';
  };
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" ];

  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'boot' | grep -v 'var' | grep -v 'home' | grep -v 'persist')

    cd /mnt-root/home
    rm -rf $(ls -A /mnt-root/home | grep -v 'kloenk' | grep -v 'pbb')
    mkdir /mnt-root/{home/public,mnt} -p

    cd /mnt-root/var
    rm -rf $(ls -A /mnt-root/var | grep -v 'src')
  '';

  systemd.tmpfiles.rules = [
    "Q /persist/data/bluetooth 750 - - - -"
    "L /var/lib/bluetooth - - - - /persist/data/bluetooht"
  ];

  networking.hostName = "samwise";
  networking.useDHCP = false;
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp2s0" ];
  environment.etc."wpa_supplicant.conf".source =
    "/var/src/secrets/wpa_supplicant.conf";
  networking.supplicant.wlp2s0.configFile.path = "/etc/wpa_supplicant.conf";
  #networking.wireless.userControlled.enable = true;
  networking.nameservers = [ "1.1.1.1" "10.0.0.2" ];

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;

  services.printing.browsing = true;
  services.printing.enable = true;
  services.avahi.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  environment.systemPackages = with pkgs; [
    spice_gtk
    ebtables
    davfs2
    #geogebra
    gtk-engine-murrine
    tango-icon-theme
    breeze-icons
    gnome3.adwaita-icon-theme
  ];

  services.tlp.enable = true;

  users.users.kloenk.initialPassword = "foobaar";
  users.users.kloenk.packages = with pkgs; [
    lm_sensors
    tpacpi-bat
    acpi # fixme: not in the kernel
    #wine # can we ditch it?
    spotifywm # spotify fixed for wms
    python # includes python2 as dependency for vscode
    platformio # pio command
    openocd # pio upload for stlink
    stlink # stlink software
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
    "dialout" # allowes serial connections
    "plugdev" # allowes stlink connection
    "davfs2" # webdav foo
    "docker" # docker controll group
    "libvirtd" # libvirt group
  ];

  # ssh key from yg-adminpc
  users.users.kloenk.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhvJ6hdf4pgsFl8c5lMuDAzUVmJwtSY/O66nDDRAK6J kloenk@adminpc"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGOQAYC5hPb/OquezdR/O9yc9PDoO5nV2/FFmLjQNFr u0_a189@localhost"
  ];

  services.udev.packages = [ pkgs.openocd ];

  services.dbus.socketActivated = true;

  services.pcscd.enable = true;
  #services.pcscd.plugins = with pkgs; [ ccid pcsc-cyberjack ];

  hardware.bluetooth.enable = true;

  # add bluetooth sink
  hardware.bluetooth.config.General.Enable = ''
    Source,Sink,Media,Socket
  '';
  hardware.pulseaudio.zeroconf.discovery.enable = true;

  nix.gc.automatic = false;

  services.prometheus.exporters.node.enabledCollectors = [ "tcpstat" "wifi" ];

  services.syncthing.dataDir = "/persist/syncthing/";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes sayyou
  # should.
  system.stateVersion = "20.09";
}
