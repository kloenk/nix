{ config, lib, pkgs, ... }:

let gitDir = "${config.services.gitolite.dataDir}/repositories";
in {
  #networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh.ports = [ 22 ];

  services.gitolite = {
    enable = true;
    user = "git";
    adminPubkey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBps9Mp/xZax8/y9fW1Gt73SkskcBux1jDAB8rv0EYUt cardno:000612029874";
    dataDir = "/persist/data/gitolite";
  };

  services.fcgiwrap.enable = true;

  services.nginx.gitweb.group = config.services.gitolite.group;
  services.nginx.virtualHosts."git.kloenk.dev" = {
    enableACME = true;
    forceSSL = true;
    root = "${pkgs.cgit}/cgit";

    #locations."/cgit.css".root    = ./cgit-assets;  
    locations."/".tryFiles = "$uri @cgit";
    locations."@cgit".extraConfig = ''
      include             ${pkgs.nginx}/conf/fastcgi_params;
      fastcgi_param       SCRIPT_FILENAME $document_root/cgit.cgi;
      fastcgi_param       PATH_INFO       $uri;
      fastcgi_param       QUERY_STRING    $args;
      fastcgi_param       HTTP_HOST       $server_name;
      fastcgi_pass        unix:/run/fcgiwrap.sock;
    '';
  };

  environment.etc.cgitrc.text = ''
        css=/cgit.css
        logo=/cgit.png
        virtual-root=/

        root-title=Kloenk's gcit
        root-desc=

        readme=:README.md
        about-filter=${pkgs.cgit}/lib/cgit/filters/about-formatting.sh

        snapshots=tar.gz tar.xz zip

        max-stats=quarter

        clone-url=http://git.kloenk.dev/$CGIT_REPO_URL git://git.kloenk.dev/$CGIT_REPO_URL ssh://git@git.kloenk.dev/$CGIT_REPO_URL

    		enable-index-links=1
        enable-commit-graph=1

        enable-log-filecount=1
        enable-log-linecount=1

        enable-http-clone=1
        enable-git-config=1
        
        mimetype.gif=image/gif
        mimetype.html=text/html
        mimetype.jpg=image/jpeg
        mimetype.jpeg=image/jpeg
        mimetype.pdf=application/pdf
        mimetype.png=image/png
        mimetype.svg=image/svg+xml

        #repos
    		repo.url=kloenk/nix
        repo.path=${gitDir}/nix.git
        repo.desc=NixOS configs
        repo.readme=master:README.md

        repo.url=facharbeit
        repo.path=${gitDir}/facharbeit.nix
        repo.desc=Files for my Facharbeit 
        repo.readme=master:README.md

        repo.url=linux/rust/kloenk
        repo.path=${gitDir}/linux/rust.git
        repo.desc=Linux Kernel with rust support
        repo.readme=rust:README
      '';
}
