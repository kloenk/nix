{ overlays ? [], nixpkgs ? <nixpkgs>, ...}@args:

import nixpkgs (args // {
  overlays = [
    (import ./overlay.nix)
  ] ++ overlays;
})
