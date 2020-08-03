{ config, pkgs, lib, ... }:

let
  #lib = pkgs.lib;
in {
  imports = [
    ../../common
  ];

  _file = ./configuration.nix;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [ vim alacritty tmux htop gnupg ripgrep onefetch fd
    ];

  #home-manager.users.kloenk = import ../../../configuration/common/home.nix {
  #  pkgs = pkgs;
  #  lib = lib;
  #};
  /*home-manager.users.kloenk = { ... }: {
    programs.git = {
      enable = true;
      userName = "Finn Behrens";
      userEmai = "me@kloenk.de";
      aliases.ls = "status";
    };
  };
  home-manager.users.kloenk = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;
  };*/

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";
  environment.variables.EDITOR = "vim";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixUnstable;
  nix.trustedUsers = [ "kloenk" ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes ca-references recursive-nix
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
