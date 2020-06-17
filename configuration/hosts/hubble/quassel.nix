{ pkgs, ... }:

{

  fileSystems."/var/lib/quassel" = {
    device = "/persist/data/quassel";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home/quassel" = {
    device = "/persist/data/quassel-home";
    fsType = "none";
    options = [ "bind" ];
  };

  services.postgresql = {
    ensureDatabases = [ "quassel" ];
    ensureUsers = [{
      name = "quassel";
      ensurePermissions."DATABASE quassel" = "ALL PRIVILEGES";
    }];
  };

  users.users.quassel.extraGroups = [ "postgres" ];

  networking.firewall.allowedTCPPorts = [ 4242 ];

  services.quassel = {
    enable = true;
    package = pkgs.quasselDaemon;
    interfaces = [ "0.0.0.0" "::" ];
    certificateFile = "/var/lib/quassel/quasselCert.pem";
    requireSSL = true;
  };

  systemd.services.quassel-cert = {
    serviceConfig = { Type = "oneshot"; };
    script = ''
      mkdir -p /var/lib/quassel
      chown quassel /var/lib/quassel
      chmod 700 /var/lib/quassel
      cat /var/lib/acme/kloenk.de/key.pem > /var/lib/quassel/quasselCert.pem
      echo >> /var/lib/quassel/quasselCert.pem
      cat /var/lib/acme/kloenk.de/fullchain.pem >> /var/lib/quassel/quasselCert.pem
      systemctl try-restart quassel
    '';
  };

  security.acme.certs."kloenk.de".postRun = "systemctl restart quassel-cert";

  systemd.services.quassel.after =
    [ "postgresql.service" "quassel-cert.service" ];
}
