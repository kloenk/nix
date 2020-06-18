{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../default.nix

    ../../common
    ../../common/pbb.nix
  ];

  hardware.cpu.intel.updateMicrocode = true;
  boot.loader.grub.device =
    "/dev/disk/by-id/wwn-0x600508b1001c577e51960d44ae47cb27";

  networking.hostName = "nixos";
  networking.useDHCP = false;
  networking.interfaces.enp2s0f0.useDHCP = true;
  networking.interfaces.enp2s0f1.useDHCP = true;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.enp3s0f1.useDHCP = true;

  networking.hosts = {
    "192.168.178.1" = [ "fritz.box" ];
    "192.168.178.248" = [ "thrain" "thrain.fritz.box" ];
  };

  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/lib/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'persist' | grep -v 'var')

    cd /mnt-root
    rm -rf $(ls -A /mnt-root/var | grep -v 'src' | grep -v 'log')

    mkdir /mnt-root/mnt

    cd /
  '';

  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;
  nix.binaryCaches = [ "https://cache.kloenk.de" ];

  networking.bridges.br0.interfaces =
    [ "enp2s0f0" "enp2s0f1" "enp3s0f0" "enp3s0f1" ];

  environment.systemPackages = with pkgs; [ lm_sensors docker virtmanager ];

  virtualisation.docker.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
  };

  users.users.kloenk.extraGroups = [ "docker" "libvirtd" ];

  system.stateVersion = "20.09";
}
