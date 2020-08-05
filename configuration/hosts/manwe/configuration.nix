{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../default.nix
    ../../common
    ../../common/pbb.nix
  ];

  # vm connection
  services.qemuGuest.enable = true;

  boot.supportedFilesystems = [ "xfs" "vfat" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices."cryptHDD".device =
    "/dev/disk/by-path/pci-0000:00:0b.0";
  boot.initrd.luks.devices."cryptSSD".device =
    "/dev/disk/by-path/pci-0000:00:0a.0-part1";

  boot.initrd.network.enable = true;
  boot.initrd.availableKernelModules = [ "virtio-pci" ];
  boot.initrd.network.ssh = {
    enable = true;
    hostKeys = [ "/var/src/secrets/initrd/ed25519_host_key" ];
  };

  # setup network
  boot.initrd.preLVMCommands = lib.mkBefore (''
    ip li set ens18 up
    ip addr add 195.39.221.187/32 dev ens18
    ip route add default via 195.39.221.1 onlink dev ens18 && hasNetwork=1
  '');

  # delete files in /
  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'boot' | grep -v 'var')

    cd /mnt-root/var
    rm -rf $(ls -A /mnt-root/var | grep -v 'src')
  '';

  networking.hostName = "manwe";
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.interfaces.ens18.ipv4.addresses = [{
    address = "195.39.221.187";
    prefixLength = 32;
  }];
  networking.interfaces.ens18.ipv6.addresses = [{
    address = "2a01:4ac0:42::f144:1";
    prefixLength = 128;
  }];

  systemd.network.networks."40-ens18".routes = [{
    routeConfig.Gateway = "195.39.221.1";
    routeConfig.GatewayOnLink = true;
  }];

  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;

  systemd.services.nixos-upgrade.path = with pkgs; [
    gnutar
    xz.bin
    gzip
    config.nix.package.out
  ];

  system.stateVersion = "20.09";
}
