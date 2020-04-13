{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./ip.nix

    ../../common/pbb.nix

    ../../default.nix
    ../../common

    # fallback for detection
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  environment.variables.NIX_PATH = lib.mkForce "/var/src";
  nix.nixPath = lib.mkForce [ "/var/src" ];

  security.acme.email = "ca@kloenk.de";
  security.acme.acceptTerms = true;

  networking.hostName = "polyus";
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.nameservers = [ "8.8.8.8" ];

  systemd.network.networks = {
    "30-enp1s0" = {
      name = "enp1s0";
      DHCP = "yes";
    };
    "10-lo" = {
      name = "lo";
      addresses = [
        { addressConfig.Address = "127.0.0.1"; }
        { addressConfig.Address = "127.0.0.53"; }
        { addressConfig.Address = "::1/128"; }
      ];
    };
    "99-how_cares" = {
      name = "*";
      linkConfig.RequiredForOnline = "no";
      linkConfig.Unmanaged = "yes";
    };
  };

  services.vnstat.enable = true;

  # auto update/garbage collector
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";
}
