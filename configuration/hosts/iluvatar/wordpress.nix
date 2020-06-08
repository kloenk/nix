{ config, pkgs, lib, ... }:

{
  services.httpd.enable = lib.mkOverride 25 false; # No thanks

  # imkerverein
  fileSystems."/var/lib/wordpress" = {
    device = "/persist/data/wordpress";
    fsType = "none";
    options = [ "bind" ];
  };

  services.wordpress.imkerverein = { };

  systemd.services.wordpress-init-imkerverein.serviceConfig.User =
    lib.mkOverride 25 config.services.nginx.user;
  systemd.services.wordpress-init-imkerverein.serviceConfig.Group =
    lib.mkOverride 25 config.services.nginx.group;
  services.phpfpm.pools.wordpress-imkerverein.settings."listen.owner" =
    lib.mkOverride 25 config.services.nginx.user;
  services.phpfpm.pools.wordpress-imkerverein.settings."group" =
    lib.mkOverride 25 config.services.nginx.group;
  services.phpfpm.pools.wordpress-imkerverein.settings."listen.group" =
    lib.mkOverride 25 config.services.nginx.group;
  services.phpfpm.pools.wordpress-imkerverein.group =
    lib.mkOverride 25 config.services.nginx.group;
  /* services.nginx.virtualHosts."burscheider-imkerverein.de" = {
       enableACME = true;
       forceSSL = true;
       locations."/" = {
         root = config.services.httpd.virtualHosts.imkerverein.documentRoot;
         extraConfig = ''
           index index.php;
           try_files $uri $uri/ /index.php?$args;
         '';
       };
       locations."~ \\.php$" = {
         root = config.services.httpd.virtualHosts.imkerverein.documentRoot;
         extraConfig = ''
           fastcgi_pass unix:${config.services.phpfpm.pools.wordpress-imkerverein.socket};
           fastcgi_index index.php;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
           include ${config.services.nginx.package}/conf/fastcgi_params;
           include ${config.services.nginx.package}/conf/fastcgi.conf;
         '';
       };
     };
  */
}
