{ config, lib, pkgs, ... }:

{
  services.restic.backups.iluvatar = {
    initialize = true;
    passwordFile = config.krops.secrets.files."restic/password".path;
    paths = [
      "/var/lib/gitea"
      "/var/backup/postgresql"
      "/var/lib/postgresql"
      "/var/backup/mysql"
      "/var/lib/mysql"
      "/var/lib/bitwarden_rs/backup"
      "/var/lib/wordpress"
    ];
    repository = "rclone:google:iluvatar";
  };

  systemd.services.restic-backups-hubble.path = [ pkgs.rclone ];
  systemd.services.restic-backups-hubble.preStart = lib.mkBefore (''
     mkdir -p /root/.config/rclone
     ln -sf ${
       config.krops.secrets.files."restic/rclone.conf".path
     } /root/.config/rclone/rclone.conf
   '');

   krops.secrets.files."restic/password".owner = "root";
   krops.secrets.files."restic/rclone.conf".owner = "root";
}
