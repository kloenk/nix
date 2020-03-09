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
  hm = options.${templateHost}.home-manager.users.kloenk;
  user = options.${templateHost}.users.users.kloenk;
in {

  home-manager = {
    home.packages = user.packages ++ hm.home.packages ++ [ pkgs.kitty.terminfo ];
    home.file = hm.home.file;
    xdg = hm.xdg;
    programs.zsh = hm.programs.zsh;
    programs.ssh = hm.programs.ssh;
    #programs.git = hm.programs.git;
    #programs.gnupg = hm.programs.gnupg;
    #services.gpg-agent = hm.services.gpg-agent;
    #wayland.windowManager.sway.extraSessionCommands = options."${templateHost}".programs.sway.extraSessionCommands;
    #wayland.windowManager.sway.enable = true;
  };

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
