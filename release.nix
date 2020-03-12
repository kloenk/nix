{
  krops
, home-manager
, nixpkgs
, nixos-mailserver
, secrets
, hydra ? true
, ...
}:

let 
  sources = {
    inherit krops home-manager nixpkgs nixos-mailserver secrets hydra;
  };
  home = (import ./lib/manager.nix sources).home;
in {
  jobsets = home;
}
