{ config, pkgs, ... }:

{

    # make sure dirs exists
    system.activationScripts = {
      media = {
        text = ''mkdir -p /media/TapeDrive /media/intenso'';
        deps = [];
      };
      srv-nfs = {
          text = ''mkdir -p /srv/nfs/Filme /srv/nfs/Books /srv/nfs/Pictures /srv/nfs/TapeDrive
                   chown -R kloenk:users /srv/nfs'';
          deps = [];
      };
    };

    #fileSystems."/media/intenso" = {
    #    device = "/dev/";
    #    fsType = "ext4";
    #    encrypted.enable = true;
    #    encrypted.blkDev = "/dev/mapper/cryptIntenso";
    #    encrypted.label = "cryptIntenso";
    #    encrypted.keyFile = "/etc/nixos/secrets/cryptIntenso.keyfile";
    #    options = [ "nofail" ];
    #};

    fileSystems."/media/TapeDrive" = {
        device = "/dev/disk/by-id/ata-WDC_WD5000AACS-00ZUB0_WD-WCASU5339750-part1";
        fsType = "ext4";
        options = [ "nofail" ];
    };

    # mount bind mounts
    fileSystems."/srv/nfs/Filme" = {
        device = "/media/intenso/Filme";
        options = [ "bind" ];
    };

    fileSystems."/srv/nfs/Books" = {
        device = "/media/intenso/Books";
        options = [ "bind" ];
    };

    fileSystems."/srv/nfs/Pictures" = {
        device = "/media/intenso/Pictures";
        options = [ "bind" ];
    };

    fileSystems."/srv/nfs/TapeDrive" = {
        device = "/media/TapeDrive";
        options = [ "bind" ];
    };


    # static ports
    services.nfs.server = {
        lockdPort  = 4001;
        mountdPort = 4002;
        statdPort  = 4000;
    };

    # open firewall
    networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 ];
    networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 ];

    # enable nfs server
    services.nfs.server.enable = true;
    services.nfs.server.exports = ''
    /srv/nfs        *(rw,sync,crossmnt,fsid=0,all_squash,anonuid=1000,anongid=1000)
    /srv/nfs/Pictures       *(rw,sync,all_squash,anonuid=1000,anongid=1000)
    /srv/nfs/Filme  *(rw,sync,all_squash,anonuid=1000,anongid=1000)
    /srv/nfs/Books  *(rw,sync,all_squash,anonuid=1000,anongid=1000)
    /srv/nfs/TapeDrive      *(rw,sync,all_squash,anonuid=1000,anongid=1000)
'';
}