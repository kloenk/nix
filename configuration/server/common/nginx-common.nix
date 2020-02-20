{ pkgs, ... }:

let
  mimetypes = pkgs.stdenv.mkDerivation rec {
    pname = "nginx-mimetypes";
    version = "2.1.48";

    src = pkgs.fetchurl {
      url = "https://releases.pagure.org/mailcap/mailcap-${version}.tar.xz";
      sha256 = "0mwiqasi7gi0c62xz769zi762p65cc36wy7nbzq3n1fn6yr27c6p";
    };

    buildPhase = ''
      sh generate-nginx-mimetypes.sh < mime.types > nginx-mime.types
    '';

    installPhase = ''
      mkdir -p $out/etc
      cp nginx-mime.types $out/etc/mime.types
    '';
  };

in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    package = pkgs.nginxMainline;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    
    commonHttpConfig = ''
      include ${mimetypes}/etc/mime.types;
      default_type application/octet-stream;

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
}