{ nixpkgs, home-manager, nixos-mailserver, secrets, ... }:

let
  sources = {
    inherit home-manager nixpkgs nixos-mailserver secrets;
  };
  pkgs = (import nixpkgs {});
  lib = pkgs.lib;
  inherit (import ./nixos-config.nix sources) options;
  templateHost = "kloenkX";
  userName = "kloenk";
  hmk = options.${templateHost}.home-manager.users.kloenk;
  user = options.${templateHost}.users.users.kloenk;
in rec {

  hm = ({
    home.packages = user.packages ++ hmk.home.packages ++ [ pkgs.kitty.terminfo ];
    home.file = hmk.home.file;
    xdg = hmk.xdg;
    programs.zsh = lib.recursiveUpdate hmk.programs.zsh {
      initExtra = "export SSH_AUTH_SOCK=/run/user/$(id -u)/gnupg/S.gpg-agent.ssh";
    };
    programs.ssh = hmk.programs.ssh;
    #programs.git = hmk.programs.git;
    #programs.gnupg = hmk.programs.gnupg;
    #services.gpg-agent = hmk.services.gpg-agent;
    #wayland.windowManager.sway.extraSessionCommands = options."${templateHost}".programs.sway.extraSessionCommands;
    #wayland.windowManager.sway.enable = true;
  });


  #home = (import (home-manager + "/home-manager/home-manager.nix") { })
  home = (import (home-manager + "/modules") {
    configuration = hm; #import ../home.nix { pkgs = pkgs; };
    lib = lib;
    pkgs = pkgs;
    check = true;
  });

  install-home-manager = (import nixpkgs {}).pkgs.writeScript "install.sh" ''
    if [ -f /home/${userName}/.config/nixpkgs/home.nix ]; then
      echo "home.nix exists, please delete"
      exit 1
    fi
    mkdir -p /home/${userName}/.config/nixpkgs/
    cat > /home/${userName}/.config/nixpkgs/home.nix <<EOF

    { pkgs, lib, ... }:

    let
      inherit (import /home/kloenk/nix/default.nix { }) home-manager;
    in {
      #inherit (import /home/kloenk/nix/default.nix { });
      home.packages = home-manager.home.packages;
    }


    EOF 
  '';

}
