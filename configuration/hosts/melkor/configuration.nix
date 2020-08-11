{ config, pkgs, lib, ... }:

{
  _file = ./configuration.nix;
  imports = [
    ./hardware-configuration.nix
    ./hydra.nix
    ./wireguard.nix

    ./postgres.nix

    ../../default.nix
    ../../common
    ../../common/pbb.nix
    ../../common/y0sh.nix

  ];

  services.qemuGuest.enable = true;

  boot.loader.grub.device = "/dev/disk/by-path/pci-0000:06:00.0";

  networking.hostName = "melkor";
  systemd.network.networks."30-enp1s0" = {
    name = "enp1s0";
    addresses = [{
      addressConfig.Address = "195.39.221.51/32";
    }
    #{ addressConfig.Address = "2a0f:4ac4:42:0:f199::3/64"; }
      ];
    routes = [{
      routeConfig = {
        Gateway = "195.39.221.1";
        GatewayOnLink = "yes";
      };
    }
    /* {
         routeConfig.Route = "195.39.221.50/32";
       }{
         routeConfig.Route = "195.39.221.54/32";
       }
    */
      ];
  };

  users.users.pbb.extraGroups = [ "wheel" ];

  system.stateVersion = "20.09";
}
