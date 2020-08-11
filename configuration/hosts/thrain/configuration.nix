{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./links.nix
    ./nfs.nix

    ./syncthing.nix

    ../../default.nix

    ../../common
    ../../common/pbb.nix
  ];

  # FIME: remove
  security.acme.server = builtins.trace "remove staging environment from acme"
    "https://acme-staging-v02.api.letsencrypt.org/directory";

  hardware.cpu.intel.updateMicrocode = true;
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;

  boot.initrd.luks.devices."cryptLVM".device =
    "/dev/disk/by-id/wwn-0x5002538e40df324b-part1";
  boot.initrd.luks.devices."cryptLVM".allowDiscards = true;
  boot.initrd.luks.devices."cryptIntenso".device =
    "/dev/disk/by-id/usb-Intenso_External_USB_3.0_20150609040398-0:0-part5";
  boot.initrd.luks.reusePassphrases = true;

  networking.useDHCP = false;
  networking.hostName = "thrain";
  networking.domain = "kloenk.de";
  networking.hosts = {
    "192.168.178.1" = lib.singleton "fritz.box";
    # TODO: barahir
    # TODO: kloenkX?
  };

  # initrd ssh server
  boot.initrd.network.enable = true;
  boot.initrd.availableKernelModules = [ "e1000e" ];
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBps9Mp/xZax8/y9fW1Gt73SkskcBux1jDAB8rv0EYUt cardno:000611120054"
    ];
    hostKeys = [ "/var/src/secrets/initrd/ed25519_host_key" ];
  };
  boot.initrd.preLVMCommands = lib.mkBefore (''
    ip li set eno1 up
    ip addr add 192.168.178.248/24 dev eno1 && hasNetwork=1
  '');

  # TODO: use bind
  networking.nameservers = [ "1.1.1.1" "192.168.178.1" "2001:4860:4860::8888" ];
  networking.search = [ "fritz.box" ];

  # transient root volume
  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/lib/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'boot' | grep -v 'persist' | grep -v 'var')

    cd /mnt-root/persist
    rm -rf $(ls -A /mnt-root/persist | grep -v 'secrets' | grep -v 'log' )

    cd /mnt-root/var
    rm -rf $(ls -A /mnt-root/var | grep -v 'src' | grep -v 'log')

    cd /mnt-root/var/src
    rm -rf $(ls -A /mnt-root/var/src | grep -v 'secrets')
  '';

  services.printing.browsing = true;
  services.printing.enable = true;
  services.avahi.enable = true;

  environment.systemPackages = with pkgs; [ lm_sensors docker virtmanager ];

  # docker
  virtualisation.docker.enable = true;

  # virtmanager
  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
  };

  users.users.kloenk.extraGroups = [
    "docker" # enable docker controll
    "libvirtd" # libvirtd connections
  ];

  # pa stream foo
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    systemWide = true;
    package = pkgs.pulseaudio;
    tcp.enable = true;
    tcp.anonymousClients.allowedIpRanges = [
      "195.39.246.0/24"
      "2a0f:4ac0::/64"
      "2a0f:4ac0:40::/44"
      "2a0f:4ac0:f199::/48"
      "192.168.178.0/24"
      "2a0a:a541:9ac9:0::/64"
    ];
  };
  networking.firewall.interfaces.eno1.allowedTCPPorts = lib.singleton 4713;

  system.autoUpgrade.enable = true;

  services.calibre-server.enable = true;
  #services.calibre-server.libraryDir = "/persist/data/syncthing/data/Library";
  users.users.calibre-server.extraGroups = [ "syncthing" ];

  system.stateVersion = "20.09";
}
