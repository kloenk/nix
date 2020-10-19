{ pkgs, ... }:

{
  fileSystems."/var/lib/pleroma" = {
    device = "/persist/data/pleroma";
    fsType = "none";
    options = [ "bind" ];
  };

  services.pleroma = {
    enable = true;
    domain = "pleroma.kloenk.dev";
    secretsEnvFile = "/var/src/secrets/pleroma/secrets-env";
    configFile = ./config.exs;
  };

  services.nginx.virtualHosts."pleroma.kloenk.dev" = {
    enableACME = true;
    forceSSL = true;
  };
}
