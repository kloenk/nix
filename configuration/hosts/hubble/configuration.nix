{ config, pkgs, lib, ... }:

# backupdirs:
#  - /var/vmail
#  - /var/dkim

let
  #secrets = import /etc/nixos/secrets.nix;
  netFace = "eth0";
in {
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix # TODO

    ./postgres.nix
    ./mysql.nix

    #./sshguard.nix
    ./dns.nix
    ./mail.nix
    ./monitoring
    ./quassel.nix
    ./deluge.nix
    #./xonotic.nix
    ./engelsystem.nix
    #./netbox.nix
    #./redis.nix
    ./restic.nix

    ../../default.nix
    ../../common
    ../../common/pbb.nix
    #    ../../bgp
  ];

  # vm connection
  services.qemuGuest.enable = true;

  # patches for systemd
  #systemd.package = pkgs.systemd.overrideAttrs (old: {
  #  patches = old.patches or [ ] ++ [
  #    (pkgs.fetchpatch {
  #      url =
  #        "https://github.com/petabyteboy/systemd/commit/c9476b836d647b470e6ff4d1bf843c9cec81748a.diff";
  #      sha256 = "1vrkykwg05bhvk1q1k5dbxgblgvx6pci19k06npfdblsf7aycfsz";
  #    })
  #  ];
  #});

  environment.etc."systemd/networkd.conf".source =
    pkgs.writeText "networkd.conf" ''
      [Network]
      DropForeignRoutes=yes
    '';

  boot.supportedFilesystems = [ "xfs" "ext2" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-path/pci-0000:00:0b.0";

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices."cryptHDD".device =
    "/dev/disk/by-partuuid/468bbd11-01";
  boot.initrd.luks.devices."cryptSSD".device =
    "/dev/disk/by-partuuid/39aacc3e-02";

  boot.initrd.network.enable = true;
  boot.initrd.availableKernelModules = [ "virtio-pci" ];
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBps9Mp/xZax8/y9fW1Gt73SkskcBux1jDAB8rv0EYUt cardno:000612029874"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9fXR2sAD3q5hHURKg2of2OoZiKz9Nr2Z7qx6nfLLMwK1nie1rFhbwSRK8/6QUC+jnpTvUmItUo+etRB1XwEOc3rabDUYQ4dQ+PMtQNIc4IuKfQLHvD7ug9ebJkKYaunq6+LFn8C2Tz4vbiLcPFSVpVlLb1+yaREUrN9Yk+J48M3qvySJt9+fa6PZbTxOAgKsuurRb8tYCaQ9TzefKJvZXIVd+W2tzYV381sSBKRyAJLu/8tA+niSJ8VwHntAHzaKzv6ozP5yBW2SB7R7owGd1cnP7znEPxB9jeDBBWLonsocwFalP1RGt1WsOiIGEPhytp5RDXWgZM5sIS42iL61hMB9Yz3PaQYLuR+1XNzdGRLIKPUDh58lGdk2P5HUqPnvE/FqfzU3jkv6ebJmcGfZiEN1TPc5ar8sQkpn56hB2DnJYWICuryTm0XpzSizf9fGyLGBw3GVBlnZjzTaBf7iokGFIu+ade5AqEjX6FxlNja1ESFNKhDAdLAHFnaKJ3u0= kloenk@kloenkX"
    ];
    port = 62954;
    hostKeys = [ "/var/src/secrets/initrd/ecdsa_host_hey" ];
  };
  # setup network
  boot.initrd.preLVMCommands = lib.mkBefore (''
    ip li set ens18 up
    ip addr add 51.254.249.187/32 dev ens18
    ip route add 164.132.202.254/32 dev ens18
    ip route add default via 164.132.202.254 dev ens18 && hasNetwork=1 
  '');

  # delet files in /
  boot.initrd.postMountCommands = ''
    cd /mnt-root
    chattr -i var/lib/empty
    rm -rf $(ls -A /mnt-root | grep -v 'nix' | grep -v 'boot' | grep -v 'persist' | grep -v 'var')

    cd /mnt-root/persist
    rm -rf $(ls -A /mnt-root/persist | grep -v 'secrets' | grep -v 'log')

    cd /mnt-root/var
    rm -rf $(ls -A /mnt-root/var | grep -v 'src' | grep -v 'log')

    cd /
  '';

  # services.openssh.hostKeys = [
  #   { bits = 4096; path = config.krops.secrets.files."ssh_host_rsa_key".path; type = "rsa"; }
  #   { path = config.krops.secrets.files."ssh_host_ed25519_key".path; type = "ed25519"; }
  # ];
  # services.openssh.extraConfig = let
  #   hostCerfiticate = pkgs.writeText "host_cert_ed25519" (builtins.readFile (toString ../../ca/ssh_host_ed25519_key_hubble-cert.pub));
  # in "HostCertificate ${hostCerfiticate}";

  # krops.secrets.files."ssh_host_rsa_key".owner = "root";
  # krops.secrets.files."ssh_host_ed25519_key".owner = "root";

  networking.firewall.allowedTCPPorts = [ 9092 ];

  networking.hostName = "hubble";
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.nameservers = [ "8.8.8.8" ];
  networking.interfaces.ens18.ipv4.addresses = [{
    address = "51.254.249.187";
    prefixLength = 32;
  }];
  networking.interfaces.ens18.ipv4.routes = [{
    address = "164.132.202.254";
    prefixLength = 32;
  }];
  #networking.defaultGateway = { address = "164.132.202.254"; interface = "enp0s18"; };
  networking.interfaces.ens18.ipv6.addresses = [{
    address = "2001:41d0:1004:1629:1337:0187::";
    prefixLength = 112;
  }];
  networking.interfaces.ens18.ipv6.routes = [{
    address = "2001:41d0:1004:16ff:ff:ff:ff:ff";
    prefixLength = 128;
  }];
  #networking.defaultGateway6 = { address = "2001:41d0:1004:16ff:ff:ff:ff:ff"; interface = "ens18"; };
  networking.extraHosts = ''
    172.0.0.1 hubble.kloenk.de
  '';
  services.resolved.enable = false; # running bind

  #systemd.network.networks."ens18".name = "ens18";
  systemd.network.networks."40-ens18".routes = [{
    routeConfig.Gateway = "164.132.202.254";
    routeConfig.GatewayOnLink = true;
  }];

  services.nginx.virtualHosts."kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    root = "/data/http/kloenk";
    locations."/PL".extraConfig =
      "return 301 https://www.dropbox.com/sh/gn1thweryxofoh3/AAC3ZW_vstHieX-9JIYIBP_ra;";
    locations."/pl".extraConfig =
      "return 301 https://www.dropbox.com/sh/gn1thweryxofoh3/AAC3ZW_vstHieX-9JIYIBP_ra;";
  };

  services.nginx.virtualHosts."key.wass-er.com" = {
    enableACME = true;
    forceSSL = true;
    root = "/etc/key.wass-er.com/";
  };
  environment.etc."key.wass-er.com/key".text = lib.fileContents ./key.wass-er;

  services.nginx.virtualHosts."cache.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://144.76.19.168:9000/nix/";
  };

  services.nginx.virtualHosts."llgcompanion.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3004/";
  };

  services.nginx.virtualHosts."schule.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    root = "/data/http/schule";
    locations."/".extraConfig = "autoindex on;";
  };

  services.nginx.virtualHosts."politics.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    root = "/data/http/schule/sw/information/";
    locations."/".extraConfig = "autoindex on;";
  };

  services.nginx.virtualHosts."fwd.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/status/lycus".extraConfig =
        "return 301 http://grafana.llg/d/OVH6Hfliz/lycus?refresh=10s&orgId=1;";
      "/status/pluto".extraConfig =
        "return 301 https://munin.kloenk.de/llg/pluto/index.html;";
      "/status/yg-adminpc".extraConfig =
        "return 301 http://grafana.llg/d/6cyIlJlmk/yg-adminpc?refresh=5s&orgId=1;";
      "/status/hubble".extraConfig = "return 301 https://grafana.kloenk.de;";
      "/video".extraConfig =
        "return 301 https://media.ccc.de/v/jh-berlin-2018-27-config_foo;";
    };
  };

  services.nginx.virtualHosts."punkte.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
  };

  services.nginx.virtualHosts."punkte.landratlucas.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3306/";
  };

  # mosh
  programs.mosh.enable = true;
  programs.mosh.withUtempter = true;

  services.vnstat.enable = true;

  # auto update/garbage collector
  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";

  # fix tar gz error in autoupdate
  systemd.services.nixos-upgrade.path = with pkgs; [
    gnutar
    xz.bin
    gzip
    config.nix.package.out
  ];

  /* services.bgp = {
       enable = true;
       localAS = 65249;
       primaryIP = "2a0f:4ac0:f199::1";
       primaryIP4 = "195.39.246.49";
       default = true;
     };
  */

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09";
}
