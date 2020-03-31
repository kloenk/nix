{ config, ... }:

let
  backupHost = "";
in {
  services.restic.backups.kloenkX = {
    repository = "rest:http://${backupHost}/kloenkX";
    timerConfig.OnActiveSec = "24h";
    initialize = true;
    passwordFile = config.krops.secrets.file."restic.key".path;
    path = [
      "/home/kloenk"
    ];
    extraBackupArgs = [
      "--exclude=/home/kloenk/Downloads"
    ];
  };
}
