{ config, ... }:

let
  secrets = import <secrets/netbox.nix>;
in {
  services.netbox = {
    enable = true;
    databasePass = "";
    redisPass = "";
    secret = secrets.secret;
    configureNginx = true;
    appDomain = "netbox.kloenk.de";
  };
}
