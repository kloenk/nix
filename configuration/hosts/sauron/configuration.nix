{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix

    ./hydra.nix
    ./postgres.nix

    ../../default.nix
    ../../common
    ../../common/pbb.nix
    ../../common/y0sh.nix
  ];

  services.qemuGuest.enable = true;

  boot.loader.grub.device = "/dev/disk/by-path/virtio-pci-0000:00:0b.0";

  #boot.initrd.preLVMCommands = lib.mkBefore (''
  #  ip li set ens18 up
  #  ip addr add 195.39.221.54/32 dev ens18
  #  ip route add default via 195.39.221.1 onlink dev ens18
  #  hasNetwork=1
  #'');

  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/lib/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'boot' | grep -v 'persist' | grep -v 'var')

    cd /mnt-root/persist
    rm -rf $(ls -A /mnt-root/persist | grep -v 'secrets' | grep -v 'logs' | grep -v 'data')

    cd /mnt-root/var
    rm -rf $(ls -A /mnt-root/var | grep -v 'src' | grep -v 'log')

    cd /mnt-root/var/src
    rm -rf $(ls -A /mnt-root/var/src | grep -v 'secrets')

    cd /
  '';

  networking.hostName = "sauron";
  networking.nameservers = [
    "2001:470:20::2"
    "2001:4860:4860::8888"
    "2001:4860:4860::8844"
    "1.1.1.1"
  ];

  systemd.network.networks."30-ens18" = {
    name = "ens18";
    addresses = [
      { addressConfig.Address = "195.39.221.54/32"; }
      { addressConfig.Address = "2a0f:4ac4:42:0:f199::1/64"; }
    ];
    routes = [{
      routeConfig = {
        Gateway = "195.39.221.1";
        GatewayOnLink = "yes";
      };
    }];
  };

  # beeing a cache but on s3 (miniio)
  nix.gc.automatic = true;
  system.autoUpgrade.enable = true;

  users.users.pbb.extraGroups = [ "wheel" ];

  system.stateVersion = "20.09";
}
