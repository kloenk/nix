{ config, lib, ... }:

{
  fileSystems."/var/vmail" = {
    device = "/persist/data/vmail";
    options = [ "bind" ];
  };

  fileSystems."/var/dkim" = {
    device = "/persist/secrets/dkim";
    options = [ "bind" ];
  };

  networking.firewall.allowedTCPPorts = [ 143 587 25 465 993 ];

  services.postfix.config = {
    #relay_domains = [ "kloenk.de" ];
    mydestination =
      lib.mkOverride 25 [ "$myhostname" "hubble.kloenk.de" "localhost" ];
    maximal_queue_lifetime = "10d";
  };

  mailserver = {
    enable = true;
    localDnsResolver = false; # already running bind
    fqdn = "mail.kloenk.de";
    domains = [
      "kloenk.de"
      "ad.kloenk.de"
      "drachensegler.kloenk.de"
      "burscheider-imkerverein.de"
    ];

    loginAccounts = {
      "kloenk@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/kloenk@kloenk.de.sha512".path;

        aliases = [
          "admin@kloenk.de"

          "postmaster@kloenk.de"
          "hostmaster@kloenk.de"
          "webmaster@kloenk.de"
          "abuse@kloenk.de"
          "postmaster@ad.kloenk.de"
          "hostmaster@ad.kloenk.de"
          "webmaster@ad.kloenk.de"
          "abuse@ad.kloenk.de"
          "postmaster@drachensegler.kloenk.de"
          "hostmaster@drachensegler.kloenk.de"
          "webmaster@drachensegler.kloenk.de"
          "abuse@drachensegler.kloenk.de"
          "postmaster@burscheider-imkerverein.de"
          "hostmaster@burscheider-imkerverein.de"
          "webmaster@burscheider-imkerverein.de"
          "abuse@burscheider-imkerverein.de"
          "delta@kloenk.de"
          "mail@kloenk.de"
        ];
      };

      "finn@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/finn@kloenk.de.sha512".path;

        aliases = [
          "finn.behrens@kloenk.de"
          "behrens.finn@kloenk.de"
          "info@kloenk.de"
          "me@kloenk.de"
        ];
      };

      "praesidium@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/praesidium@kloenk.de.sha512".path;

        aliases = [ "präsidium@kloenk.de" ];
      };

      "chaos@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/chaos@kloenk.de.sha512".path;

        aliases =
          [ "35c3@kloenk.de" "eventphone@kloenk.de" "cryptoparty@kloenk.de" ];
      };

      "schule@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/schule@kloenk.de.sha512".path;
        aliases = [ "moodle+llg@kloenk.de" ];
      };

      "yougen@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/yougen@kloenk.de.sha512".path;
      };

      "grafana@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/grafana@kloenk.de.sha512".path;
      };

      "eljoy@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/eljoy@kloenk.de.sha512".path;
        aliases = [ "eljoy2@kloenk.de" ];
      };

      "noreply-punkte@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/nrpunkte@kloenk.de.sha512".path;
      };

      "alertmanager@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/alert@kloenk.de.sha512".path;
      };

      "ad@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/ad@kloenk.de.sha512".path;

        aliases = [
          "llgcompanion@kloenk.de"
          "telegram@kloenk.de"
          "fff@kloenk.de"
          "punkte@kloenk.de"
        ];

        catchAll = [ "kloenk.de" "ad.kloenk.de" ];
      };

      "drachensegler@drachensegler.kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/drachensegler@drachensegler.kloenk.de.sha512".path;

        aliases = [
          "drachensegler@kloenk.de"
          "dlrg@drachensegler.kloenk.de"
          "tjaard@drachensegler.kloenk.de"
          "tjaard@kloenk.de"
          "schule@drachensegler.kloenk.de"
          "iandmi@drachensegler.kloenk.de"
          "iandme@drachensegler.kloenk.de"
          "autodesk@drachensegler.kloenk.de"
        ];

        catchAll = [ "drachensegler.kloenk.de" ];
      };

      "git@kloenk.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/git@kloenk.de.sha512".path;
      };

      # burscheider-imkerverein
      "tjaard@burscheider-imkerverein.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/drachensegler@drachensegler.kloenk.de.sha512".path;
      };

      "info@burscheider-imkerverein.de" = {
        hashedPasswordFile =
          config.krops.secrets.files."mail/info@burscheider-imkerverein.de.sha512".path;

        catchAll = [ "burscheider-imkerverein.de" ];
      };
    };

    extraVirtualAliases = {
      #"schluempfli@kloenk.de" = "holger@trudeltiere.de";
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;

    enableImap = true;
    enablePop3 = false;
    enableImapSsl = true;
    enablePop3Ssl = false;

    # Enable the ManageSieve protocol
    enableManageSieve = true;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;
  };

  krops.secrets.files = {
    "mail/kloenk@kloenk.de.sha512".owner = "root";
    "mail/finn@kloenk.de.sha512".owner = "root";
    "mail/praesidium@kloenk.de.sha512".owner = "root";
    "mail/chaos@kloenk.de.sha512".owner = "root";
    "mail/schule@kloenk.de.sha512".owner = "root";
    "mail/yougen@kloenk.de.sha512".owner = "root";
    "mail/grafana@kloenk.de.sha512".owner = "root";
    "mail/eljoy@kloenk.de.sha512".owner = "root";
    "mail/nrpunkte@kloenk.de.sha512".owner = "root";
    "mail/alert@kloenk.de.sha512".owner = "root";
    "mail/ad@kloenk.de.sha512".owner = "root";
    "mail/git@kloenk.de.sha512".owner = "root";
    "mail/drachensegler@drachensegler.kloenk.de.sha512".owner = "root";
    "mail/info@burscheider-imkerverein.de.sha512".owner = "root";
  };
  users.users.engelsystem.extraGroups = [ "keys" ];
}
