{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix # TODO

    ../../default.nix
    ../../common

    # fallback for detection
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  # hardware foo
  boot.supportedFilesystems = [ "ext2" "xfs" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-path/virtio-pci-0000:04:00.0";
  boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  networking.hostName = "planets";
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.nameservers =
    [ "8.8.8.8" "2001:4860:4860::8888" "8.8.4.4" "2001:4860:4860::8844" ];
  networking.interfaces.enp1s0.macAddress = "52:54:00:f0:aa:b4";
  networking.interfaces.enp1s0.ipv6.addresses = [
    {
      address = "2001:678:bbc:3e7:f199::1";
      prefixLength = 64;
    }
    {
      address = "fe80::5054:ff:fef0:aab4";
      prefixLength = 64;
    }
  ];
  networking.interfaces.enp1s0.ipv6.routes = [{
    address = "fe80::5054:ff:fefb:9c31";
    prefixLength = 128;
  }]; # TODO
  networking.extraHosts = ''
    planets.kloenk.de 127.0.0.1
  '';

  services.vnstat.enable = true;

  #services.bgp = {
  #  enable = true;
  #  localAS = 65249;
  #  primaryIP = "2a0f:4ac0:f199::3";
  #  primaryIP4 = "195.39.246.51";
  #  default = true;
  #};

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";
}
