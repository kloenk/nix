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
  boot.extraModulePackages = with config.boot.kernelPackages; [
    wireguard
  ];

  # initrd network
  boot.initrd.network.enable = true;
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9fXR2sAD3q5hHURKg2of2OoZiKz9Nr2Z7qx6nfLLMwK1nie1rFhbwSRK8/6QUC+jnpTvUmItUo+etRB1XwEOc3rabDUYQ4dQ+PMtQNIc4IuKfQLHvD7ug9ebJkKYaunq6+LFn8C2Tz4vbiLcPFSVpVlLb1+yaREUrN9Yk+J48M3qvySJt9+fa6PZbTxOAgKsuurRb8tYCaQ9TzefKJvZXIVd+W2tzYV381sSBKRyAJLu/8tA+niSJ8VwHntAHzaKzv6ozP5yBW2SB7R7owGd1cnP7znEPxB9jeDBBWLonsocwFalP1RGt1WsOiIGEPhytp5RDXWgZM5sIS42iL61hMB9Yz3PaQYLuR+1XNzdGRLIKPUDh58lGdk2P5HUqPnvE/FqfzU3jkv6ebJmcGfZiEN1TPc5ar8sQkpn56hB2DnJYWICuryTm0XpzSizf9fGyLGBw3GVBlnZjzTaBf7iokGFIu+ade5AqEjX6FxlNja1ESFNKhDAdLAHFnaKJ3u0= kloenk@kloenkX"
    ];
    port = 62954;
  };
  boot.initrd.preLVMCommands = lib.mkBefore (''
    ip li set enp1s0 up
    ip -6 addr add 2001:678:bbc::/128 dev enp1s0
    ip -6 route add 2001:678:bbc::/128 dev enp1s0
    ip -6 route add default via 2001:678:bbc::/128 dev enp1s0 && hasNetwork=1 
  ''); # TODO


  networking.hostName = "planets";
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.nameservers = [ "8.8.8.8" "2001:4860:4860::8888" "8.8.4.4" "2001:4860:4860::8844" ];
  networking.interfaces.enp1s0.ipv6.addresses = [ { address = "2001:678:bbc::"; prefixLength = 128; } ]; # TODO
  networking.interfaces.enp1s0.ipv6.routes = [ { address = "2001:678:bbc::"; prefixLength = 128; } ]; # TODO
  networking.extraHosts = ''
    planets.kloenk.de 127.0.0.1
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
