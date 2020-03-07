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

  networking.hostName = "planets";
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.nameservers = [ "8.8.8.8" ];
  networking.interfaces.enp1s0.useDHCP = true;
  networking.extraHosts = ''
  '';

  services.vnstat.enable = true;

  services.bgp = {
    enable = true;
    localAS = 65249;
    primaryIP = "2a0f:4ac0:f199::3";
    primaryIP4 = "195.39.246.51";
    default = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";
}
