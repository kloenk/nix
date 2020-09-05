{ config, lib, pkgs, ... }:

{
  fileSystems."/var/lib/gitea" = {
    device = "/persist/data/gitea";
    fsType = "none";
    options = [ "bind" ];
  };

  # use openssh as ssh server for cert key
  services.openssh.ports = [ 22 ];

  services.gitea = {
    enable = true;
    stateDir = "/var/lib/gitea";
    log.level = "Warn";
    appName = "Kloenk's Gitea";
    domain = "git.kloenk.de";
    rootUrl = "https://git.kloenk.de";
    httpAddress = "127.0.0.1";
    httpPort = 3000;
    cookieSecure = true;
    user = "git";

    database = {
      type = "postgres";
      name = "git";
      user = "git";
      createDatabase = true;
    };

    settings = builtins.trace "add signingkey to gitea" {
      repository.PREFERRED_LICENSES =
        "AGPL-3.0,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";
      server = {
        START_SSH_SERVER = false;
        BUILTIN_SSH_SERVER_USER = "git";
        SSH_PORT = 22;
        DISABLE_ROUTER_LOG = true;
        SSH_CREATE_AUTHORIZED_KEYS_FILE = false;
      };
      mailer = {
        ENABLE = true;
        SUBJECT = "%(APP_NAME)s";
        HOST = "localhost:587";
        USER = "git@kloenk.de";
        SEND_AS_PLAIN_TEXT = true;
        USE_SENDMAIL = false;
        FROM = ''"Kloenks's Gitea" <gitea@kloenk.de>'';
      };
      attachment.ALLOWED_TYPES = "*/*";

      services = {
        SKIP_VERIFY = true;
        REGISTER_EMAIL_CONFIRM = true;
        ENABLE_NOTIFY_MAIL = true;
        ENABLE_CAPTCHA = false;
        NO_REPLY_ADDRESS = "kloenk.de";
        DISABLE_REGISTRATION = true;
      };
    };
  };

  services.nginx.virtualHosts."git.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3000";
  };

  #systemd.services.gitea.serviceConfig.AmbientCapabilities = "cap_net_bind_service";
  systemd.services.gitea.serviceConfig.SystemCallFilter = lib.mkForce
    "~@clock @cpu-emulation @debug @keyring @memlock @module @obsolete @raw-io @reboot @resources @setuid @swap";

  users.users.git = {
    description = "Gitea user";
    home = config.services.gitea.stateDir;
    useDefaultShell = true;
    group = "gitea";
  };

  services.openssh.extraConfig = ''
    Match User git
      AuthorizedKeysCommandUser git
      AuthorizedKeysCommand ${pkgs.gitea}/bin/gitea keys -e git -u %u -t %t -k %k
    Match all
  '';
}
