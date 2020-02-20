{ pkgs, config, ... }:

{
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
    #useSubstitutes = true;
    notificationSender = "hydra@pbb.lc";
    # Todo mail
  };

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

  # use localhost for builds
  nix.extraOptions = ''
    allowed-uris = https://git.pbb.lc ; https://github.com ; https://cgit.krebsco.de ; https://gitlab.com
  '';
  
  nix.buildMachines = [
    {
      hostName = "localhost";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
      maxJobs = 20;
    }
  ];
}
