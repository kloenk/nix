{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    enable = true;
    package = pkgs.nginxMainline;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslCiphers = "TLSv1.2+HIGH+ECDHE@STRENGTH";

    commonHttpConfig = ''
      charset utf-8;
      map $scheme $hsts_header {
        https "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;
      add_header 'Referrer-Policy' 'same-origin';
      add_header X-Frame-Options DENY;
      add_header X-Content-Type-Options nosniff;
      add_header X-XSS-Protection "1; mode=block";

      # This might create errors
      #proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
    '';
  };
  services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de" = {
    #enableACME = true;
    #forceSSL = true;
    locations."/public/".alias = "/mnt/data/pbb/public/";
  };
}