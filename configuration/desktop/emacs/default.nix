{ config, pkgs, inputs, ... }:

/*let
  doom-emacs = pkgs.callPackage (inputs.doom-emacs) {
    doomPrivateDir = ./doom.d;
    bundledPackages = false;
    emacsPackages = (pkgs.emacsPackagesGen pkgs.emacs-pgtk);
  };
in {
  services.emacs = {
    enable = true;
    package = doom-emacs;
  };

  home-manager.users.kloenk.home.file.".emacs.d/init.el".text = ''
    (load "default.el")
  '';
}*/

let
  emacs = pkgs.emacs-pgtk;
  emacsWithPackages = (pkgs.emacsPackagesGen emacs).emacsWithPackages;
  emacsBuild = emacsWithPackages (epkgs:
    (with epkgs; [
      magit
      zerodark-theme
      nix-mode
      elixir-mode

      company

      evil
      evil-magit

      doom-themes
      doom-modeline

      pass
      password-store
      password-store-otp

      neotree

      # lang
      ccls
      org

      hl-todo # todo highlighting
      minimap

      wolfram # wolfram alpha queries (M-x wolfram-alpha <query>)
    ] ++ (with epkgs.melpaPackages; [
      #modeline
    ])));
in {
  services.emacs = {
    enable = true;
    package = emacsBuild;
  };

  #home-manager.users.kloenk.home.file.".doom.d".source = ./doom.d; # TODO: restart emacs?
  home-manager.users.kloenk.home.file.".emacs.d/init.el".source = ./init.el;
}
