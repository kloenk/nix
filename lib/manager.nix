{ nixpkgs, home-manager, nixos-mailserver, secrets, ... }:

let
  sources = {
    inherit home-manager nixpkgs nixos-mailserver secrets;
  };
  lib = (import nixpkgs {}).lib;
  inherit (import ./nixos-config.nix sources) options;
  templateHost = "kloenkX";
  user = "kloenk";
  hm = options.${templateHost}.home-manager.users.kloenk;
  user = options.${templateHost}.users.users.kloenk;
in {

  home-manager = (lib.recursiveUpdate hm {
    home.packages = user.packages ++ options."${templateHost}".environment.systemPackages;
  });

  install-home-manager = (import nixpkgs {}).pkgs.writeScript "install.sh" ''
    if [ -f /home/${user}/.config/nixpkgs/home.nix ]; then
      echo "home.nix exists, please delete"
      exit 1
    fi
    mkdir -p /home/${user}/.config/nixpkgs/
    cat > /home/${user}/.config/nixpkgs/home.nix <<EOF

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
