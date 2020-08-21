{ config, pkgs, ... }:

let
  emacs = pkgs.emacs-pgtk;
  emacsWithPackages = (pkgs.emacsPackagesGen emacs).emacsWithPackages;
  emacsBuild = emacsWithPackages (epkgs:
    (with epkgs.melpaPackages; [
      magit
      zerodark-theme
      doom-themes
      #undo-tree
      nix-mode
      elixir-mode

      evil

      wolfram # wolfram alpha queries (M-x wolfram-alpha <query>)
    ]));
in {
  services.emacs = {
    enable = true;
    package = emacsBuild;
  };
}
