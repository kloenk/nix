{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    #./wireguard.nix

    ../../default.nix
    ../../common

    (modulesPath + "/installer/cd-dvd/sd-image-aarch64.nix")
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_4_19;

  networking.wireless.enable = true;

  networking.hostName = "veantur";

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    keyMap = "de";
  };

  services.openssh.ports = [ 62954 ];

  environment.systemPackages = with pkgs; [
    wget
    vim
    curl
    tmux
    htop
    nload
  ];

  users.users.kloenk.initialPassword = "foobar";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
