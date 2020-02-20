{ ... }:

let
  secrets = import <secrets/mail.nix>;

in {
  fileSystems."/var/vmail" = {
    device = "/ssd/vmail";
    options = [ "bind" ];
  };

  imports = [
    <sources/nixos-mailserver>
  ];

  networking.firewall.allowedTCPPorts = [ 143 587 25 465 993 ];

  mailserver = {
      enable = true;
      localDnsResolver = false; # already running bind
      fqdn = "mail.kloenk.de";
      domains = [ "kloenk.de" "ad.kloenk.de" "drachensegler.kloenk.de" ];


      loginAccounts = {
          "kloenk@kloenk.de" = {
              hashedPassword = secrets.kloenk;

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
                  "delta@kloenk.de"
                  "mail@kloenk.de"
              ];
          };


          "finn@kloenk.de" = {
              hashedPassword = secrets.finn;

              aliases = [
                  "finn.behrens@kloenk.de"
                  "behrens.finn@kloenk.de"
                  "info@kloenk.de"
                  "me@kloenk.de"
              ];
          };

          "praesidium@kloenk.de" = {
            hashedPassword = secrets.praesidium;

            aliases = [
              "präsidium@kloenk.de"
            ];
          };

          "chaos@kloenk.de" = {
              hashedPassword = secrets.chaos;

              aliases = [
                  "35c3@kloenk.de"
                  "eventphone@kloenk.de"
                  "cryptoparty@kloenk.de"
              ];
          };

          "schule@kloenk.de" = {
              hashedPassword = secrets.schule;
          };

          "yougen@kloenk.de" = {
              hashedPassword = secrets.yougen;
          };

          "grafana@kloenk.de" = {
              hashedPassword = secrets.grafana;
          };

          "gitlab@kloenk.de" = {
              hashedPassword = secrets.gitlab;
          };

          "lkml@kloenk.de" = {
              hashedPassword = secrets.lkml;
          };

          "eljoy@kloenk.de" = {
              hashedPassword = secrets.eljoy;
              aliases = [
                "eljoy2@kloenk.de"
              ];
          };

          "noreply-punkte@kloenk.de" = {
            hashedPassword = secrets.nrpunkte;
          };

          "alertmanager@kloenk.de" = {
            hashedPassword = secrets.alert;
          };

          "ad@kloenk.de" = {
              hashedPassword = secrets.ad;

              aliases = [
                  "llgcompanion@kloenk.de"
                  "telegram@kloenk.de"
                  "fff@kloenk.de"
                  "punkte@kloenk.de"
              ];

              catchAll = [
                "kloenk.de"
                "ad.kloenk.de"
            ];
          };

          "drachensegler@drachensegler.kloenk.de" = {
              hashedPassword = secrets.drachensegler;

              aliases = [
                  "drachensegler@kloenk.de"
                  "dlrg@drachensegler.kloenk.de"
                  "tjaard@drachensegler.kloenk.de"
                  "tjaard@kloenk.de"
                  "schule@drachensegler.kloenk.de"
              ];

              catchAll = [
                  "drachensegler.kloenk.de"
              ];
          };

          "git@kloenk.de" = {
              hashedPassword = secrets.git;
          };

          "information@kloenk.de" = {
              hashedPassword = secrets.information;
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
}
