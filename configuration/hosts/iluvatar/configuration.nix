{ configs, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix

    #./minecraft.nix
    ./bitwarden.nix
    ./postgres.nix
    #./gitea.nix
    ./cgit.nix
    ./website.nix
    ./restic.nix

    ./wordpress.nix
    ./mysql.nix

    ./dns.nix
    ./mail.nix
    ./quassel.nix

    ../../default.nix
    ../../common
  ];

  # vm connection
  services.qemuGuest.enable = true;

  boot.loader.grub.device = "/dev/disk/by-path/virtio-pci-0000:04:00.0";

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices.cryptHDD.device =
    "/dev/disk/by-path/virtio-pci-0000:05:00.0";
  boot.initrd.luks.devices.cryptSSD.device =
    "/dev/disk/by-path/virtio-pci-0000:04:00.0-part2";

  # initrd network
  boot.initrd.network.enable = true;
  boot.initrd.availableKernelModules = [ "virtio-pci" ];
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBps9Mp/xZax8/y9fW1Gt73SkskcBux1jDAB8rv0EYUt cardno:000612029874"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9fXR2sAD3q5hHURKg2of2OoZiKz9Nr2Z7qx6nfLLMwK1nie1rFhbwSRK8/6QUC+jnpTvUmItUo+etRB1XwEOc3rabDUYQ4dQ+PMtQNIc4IuKfQLHvD7ug9ebJkKYaunq6+LFn8C2Tz4vbiLcPFSVpVlLb1+yaREUrN9Yk+J48M3qvySJt9+fa6PZbTxOAgKsuurRb8tYCaQ9TzefKJvZXIVd+W2tzYV381sSBKRyAJLu/8tA+niSJ8VwHntAHzaKzv6ozP5yBW2SB7R7owGd1cnP7znEPxB9jeDBBWLonsocwFalP1RGt1WsOiIGEPhytp5RDXWgZM5sIS42iL61hMB9Yz3PaQYLuR+1XNzdGRLIKPUDh58lGdk2P5HUqPnvE/FqfzU3jkv6ebJmcGfZiEN1TPc5ar8sQkpn56hB2DnJYWICuryTm0XpzSizf9fGyLGBw3GVBlnZjzTaBf7iokGFIu+ade5AqEjX6FxlNja1ESFNKhDAdLAHFnaKJ3u0= kloenk@kloenkX"
    ];
    port = 62954;
    hostKeys = [
      "/var/src/secrets/initrd/ed25519_host_key"
      "/var/src/secrets/initrd/ecdsa_host_key"
    ];
  };
  boot.initrd.preLVMCommands = lib.mkBefore (''
    ip li set enp1s0 up
    ip addr add 195.39.247.6/32 dev enp1s0
    ip route add default via 195.39.247.2 onlink dev enp1s0
    # some ip stuff??
    hasNetwork=1
  '');

  # delet files in /
  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/lib/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'boot' | grep -v 'persist' | grep -v 'var')

    cd /mnt-root/persist
    rm -rf $(ls -A /mnt-root/persist | grep -v 'secrets' | grep -v 'logs')

    cd /mnt-root/var
    rm -rf $(ls -A /mnt-root/var | grep -v 'src' | grep -v 'log')

    cd /mnt-root/var/src
    rm -rf $(ls -A /mnt-root/var/src | grep -v 'secrets')

    cd /
  '';

  networking.hostName = "iluvatar";
  networking.domain = "kloenk.de";
  networking.nameservers = [
    "2001:470:20::2"
    "2001:4860:4860::8888"
    "2001:4860:4860::8844"
    "1.1.1.1"
  ];
  networking.extraHosts = # FIXME: replace with ’networking.hosts‘
    ''
      127.0.0.1 iluvatar.kloenk.de
    '';

  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.interfaces.enp1s0.ipv6.addresses = [{
    address = "2a0f:4ac0::6";
    prefixLength = 128;
  }];
  networking.interfaces.enp1s0.ipv4.addresses = [{
    address = "195.39.247.6";
    prefixLength = 32;
  }];

  # default gateway
  systemd.network.networks."40-enp1s0" = {
    name = "enp1s0";
    networkConfig = { IPv6AcceptRA = "no"; };
    routes = [
      {
        routeConfig.Gateway = "2a0f:4ac0::2";
        routeConfig.GatewayOnLink = "yes";
        routeConfig.PreferredSource = "2a0f:4ac0::6";
      }
      {
        routeConfig.Gateway = "195.39.247.2";
        routeConfig.GatewayOnLink = "yes";
      }
    ];
  };

  services.nginx.virtualHosts."cache.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."= /".proxyPass = "http://144.76.19.168:9000/nix/index.html";
    locations."/".proxyPass = "http://144.76.19.168:9000/nix/";
  };

  # running bind
  services.resolved.enable = false;

  services.vnstat.enable = true;

  # auto update/garbage collector
  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;
  #nix.gc.options = "--delete-older-than 4d";
  #systemd.services.nixos-upgrade.path = with pkgs; [  gnutar xz.bin gzip config.];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09";
}
