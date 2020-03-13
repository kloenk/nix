{ lib, config, pkgs, ... }:

let
  cfg = config.services.engelsystem;
  package = pkgs.engelsystem;

in {
  options = with lib; {
    services.engelsystem = {
      enable = mkEnableOption "Engelsystem";
      extraConfig = mkOption {
        type = types.lines;
        description = ''
          Engelsystem config
        '';
      };

      domain = mkOption {
        type = types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."engelsystem/config.php".source = pkgs.writeTextFile {
      name = "config.php";
      text = cfg.extraConfig;
      checkPhase = ''
        ${pkgs.php}/bin/php -l $out
      '';
    };

    services.phpfpm.pools."engelsystem" = {
      user = "engelsystem";
      settings = {
        "listen.owner" = config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
#        "security.limit_extensions" = "";
      };
      phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.domain}".locations  = {
        "/" = {
          root = "${package}/share/engelsystem/public";
          extraConfig = ''
            index index.php;
            try_files $uri $uri/ /index.php?$args;
            autoindex off;
          '';
          #extraConfig = ''
          #  fastcgi_split_path_info ^(.+\.php)(/.+)$;
          #  fastcgi_pass unix:${config.services.phpfpm.pools.engelsystem.socket};
          #  fastcgi_index index.php;
          #  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          #  include ${config.services.nginx.package}/conf/fastcgi_params;
          #  include ${config.services.nginx.package}/conf/fastcgi.conf;
          #'';
        };
        "~ \\.php$" = {
          root = "${package}/share/engelsystem/public";
          extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.engelsystem.socket};
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include ${config.services.nginx.package}/conf/fastcgi_params;
            include ${config.services.nginx.package}/conf/fastcgi.conf;
          '';
        };
      };
    };

    #system.activationScripts = {
    #  engelsystem-state-dir = {
    #    text = ''
    #      mkdir -p /var/lib/engelsystem
    #      chown -R engelsystem:engelsystem /var/lib/engelsystem
    #    '';
    #    deps = [];
    #  };
    #};

    users.users.engelsystem = {
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/engelsystem";
      group = "engelsystem";
    };
    users.groups.engelsystem = {};
  };
}
