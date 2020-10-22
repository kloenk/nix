{ config, pkgs, lib, ... }:

{
  _file = ./configuration.nix;
  imports = [
    ./hardware-configuration.nix

    ../../default.nix
    ../../common
  ];

  services.qemuGuest.enable = true;

  # bootloader
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # transient root voluem
  /* boot.initrd.postMountCommands = ''
       cd /mnt-root
       chattr -i var/lib/empty
       rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'persist' | grep -v 'var')

       cd /mnt-root/persist
       rm -rf $(ls -A /mnt-root/persist | grep -v 'data' )

       cd /mnt-root/var
       rm -rf $(ls -A /mnt-root/var | grep -v 'src')

       cd /
     '';
  */

  boot.initrd.luks.reusePassphrases = true;

  networking.hostName = "robotnix";
  systemd.network.networks."30-enp1s0" = {
    name = "enp1s0";
    addresses = [{ addressConfig.Address = "195.39.221.59/32"; }];
    routes = [{
      routeConfig = {
        Gateway = "195.39.221.1";
        GatewayOnLink = "yes";
      };
    }];
  };

  system.stateVersion = "21.03";
}
