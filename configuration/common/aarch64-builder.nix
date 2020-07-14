{ config, ... }:

{
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "aarch64.nixos.community";
        maxJobs = 64;
        sshKey = "/var/src/secrets/aarch64-key";
        sshUser = "kloenk";
        system = "aarch64-linux";
        supportedFeatures = [ "big-parallel" ];
      }
    ];
  };

}
