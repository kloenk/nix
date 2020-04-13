{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./hydra.nix
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

  networking.hostName = "gurke";
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.nameservers = [ "8.8.8.8" ];
  networking.extraHosts = ''
    127.0.0.1 cache
  '';

  users.users.pbb.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBLztxsM/lUG8RAF5jQTrZuPIux6RiE8hoh1hvoCVal+ytNP8H76rOLkP+NHoEmF+tfiQCj5FIogr1xTWUanUhCSIXf2g6pr9msIALjvNz6v5No5W4f9M5weMG37s3C7qWQNGJHwpFV2ZdsgRQKgyesXNaKTwyVrfj+hPB/O0PosccSgVw9lJGXiCpqpicp57PLUZsrPhIcYnSyy2JhD/8NzO+BR4C1PQubgp1edzyLLS2tZed3/PkMnQh+rrFDaeUKm0HOkCYv6ZXLq0JuJor1FlETIMtg/z3oUvyUrkUfBBf0PYYrpeXn8u0qMk7luCDqNPwWiwH7e5i32jy6/K9+pk5yiMwaLgjwZYuAfjOTbVMf1TqkkFl8BXzQqzSzm+dsZKnEiDAERo3iWEcLeq9uaYYjiIDWNgm3G3BMJlw22VECr7T3kgXTfxwrqr3Jzu8npd1PIOR83ByseegC1wTw3hmq8rLKuYdEUp0kSzYzC2ciGfpamKcGEnxvkXAz0E= pbb@amalthea"
  ];

  systemd.network.networks = {
    "30-enp1s0" = {
      name = "enp1s0";
      addresses = [
        { addressConfig.Address = "195.39.246.6/28"; }
        { addressConfig.Address = "2a0f:4ac0:42::6/64"; }
      ];
      routes = [
        {
          routeConfig.Gateway = "195.39.246.1";
          routeConfig.GatewayOnLink = true;
        }
        {
          routeConfig.Gateway = "2a0f:4ac0:42::1";
          routeConfig.GatewayOnLink = true;
        }
      ];
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
