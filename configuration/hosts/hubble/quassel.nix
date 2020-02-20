{ pkgs, ... }:

{
    networking.firewall.allowedTCPPorts = [ 4242 ];

    services.quassel = {
        enable = true;
        package = pkgs.quasselDaemon;
        interfaces = [ "0.0.0.0" "::"];
        dataDir = "/srv/quassel";
        certificateFile = "/srv/quassel/quasselCert.pem";
        requireSSL = true;
    };


    systemd.services.quassel-cert = {
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      mkdir -p /srv/quassel
      chown quassel /srv/quassel
      chmod 700 /srv/quassel
      cat /var/lib/acme/kloenk.de/key.pem > /srv/quassel/quasselCert.pem
      echo >> /srv/quassel/quasselCert.pem
      cat /var/lib/acme/kloenk.de/fullchain.pem >> /srv/quassel/quasselCert.pem
      systemctl try-restart quassel
    '';
  };

  security.acme.certs."kloenk.de".postRun = "systemcdl restart quassel-cert";

  systemd.services.quassel.after = [ "quassel-cert" ];
}
