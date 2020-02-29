{ pkgs, config, ... }:

{

   nixpkgs.config.allowBroken = true;

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "hydra" ];
    ensureUsers = [
      { name = "hydra";
        ensurePermissions."DATABASE hydra" = "ALL PRIVILEGES";
      }
    ];
  };

  services.hydra = {
    enable = true;
    hydraURL = "hydra.pbb.lc";
    port = 3015;
    listenHost = "127.0.0.1";
    logo = ./hydra.png;
    #useSubstitutes = true;
    notificationSender = "hydra@pbb.lc";
    # Todo mail
  };

  services.hydra.debugServer = true;

  services.nginx.virtualHosts."hydra.pbb.lc" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3015";
  };

  services.nginx.virtualHosts."hydra.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3015";
  };

  # serve as cache
  services.nix-serve = {
    enable = true;
    secretKeyFile = config.krops.secrets.files."cache-priv-key.pem".path;
  };

  krops.secrets.files."cache-priv-key.pem".owner = "nix-store";
  users.users.nix-store.extraGroups = [ "keys" ];

  services.nginx.virtualHosts."cache.kloenk.de" = {
    #serverAliases = [ "cache" "binarycache" "binarychache.kloenk.de" ];
    enableACME = true;
    forceSSL = true;
    locations."/".extraConfig = ''
      proxy_pass http://localhost:${toString config.services.nix-serve.port};
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    '';
  };
  # use localhost for builds
  
  nix.buildMachines = [
    {
      hostName = "localhost";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
      maxJobs = 8; # 20;
    }
  ];
}
