{ ... }:

{
  disabledModules = [ "services/networking/bird.nix" ];
  imports = [ ./deluge.nix ./ferm2 ./secrets ./bird2 ./firefox ];
}
