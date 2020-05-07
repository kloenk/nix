{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../default.nix

    ../../common
    ../../common/pbb.nix
  ];

  # vm agent connection
  services.qemuGuest.enable = true;
  networking.useDHCP = false;

  boot.loader.grub.device = builtins.trace "TODO: grub device" "/dev/null";

  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/lib/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'persist' | grep -v 'var')

    cd /mnt-root/persist
    rm -rf $(ls -A /mnt-root/persist | grep -v 'data')

    cd /mnt-root/var
    rm -rf $(ls -A /mnt-root/var | grep -v 'src' | grep -v 'log' )

    cd /mnt-root/var/src
    rm -rf $(ls -A /mnt-root/var/src | grep -v 'secrets')

    cd /
  '';

  networking.hostName = "eradan";
  networking.domain = "kloenk.de";
  networking.nameservers = [ "1.1.1.1" "192.168.178.1" "2001:4860:4860::8888" ];
  networking.hosts = {
    "192.168.178.1" = lib.singleton "fritz.box";
    "192.168.178.248" = [ "thrain" "thrain.fritz.box" "thrain.kloenk.de" ];
    "192.168.178.95" = [ "barahir" "barahir.fritz.box" "barahir.kloenk.de" ];
  };

  system.stateVersion = "20.09";
}
