{ config, pkgs, lib, ... }:

{
  _file = ./configuration.nix;
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix

    ./deluge.nix

    ../../default.nix
    ../../common
  ];

  services.qemuGuest.enable = true;

  # bootloader
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # transient root voluem
  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/lib/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'persist' | grep -v 'var')

    cd /mnt-root/persist
    rm -rf $(ls -A /mnt-root/persist | grep -v 'data' )

    cd /mnt-root/var
    rm -rf $(ls -A /mnt-root/var | grep -v 'src')

    cd /
  '';

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices.cryptHDD.device =
    "/dev/disk/by-path/virtio-pci-0000:05:00.0";
  boot.initrd.luks.devices.cryptSSD.device =
    "/dev/disk/by-path/virtio-pci-0000:04:00.0-part1";

  networking.hostName = "bombadil";
  systemd.network.networks."30-enp1s0" = {
    name = "enp1s0";
    addresses = [{ addressConfig.Address = "195.39.221.52/32"; }];
    routes = [{
      routeConfig = {
        Gateway = "195.39.221.1";
        GatewayOnLink = "yes";
      };
    }];
  };

  boot.initrd.network.enable = true;
  boot.initrd.availableKernelModules = [ "virtio-pci" ];
  boot.initrd.network.ssh.enable = true;

  boot.initrd.preLVMCommands = lib.mkBefore (''
    ip li set dev enp1s0 up
    ip addr add 195.39.221.52/32 dev enp1s0
    ip route add default via 192.39.221.1 onlink dev enp1s0
    hasNetwork=1
  '');

  system.stateVersion = "21.03";
}
