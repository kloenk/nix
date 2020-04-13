{
  edition = 201909;

  description = "Kloenk's Nixos configuration";

  inputs.home-manager = {
    type = "github";
    owner = "kloenk";
    repo = "home-manager";
    ref = "feature/flake-overlay";
    inputs.nixpkgs.follows = "/nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager }:
    let

      systems = [ "x86_64-linux" ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      # Memoize nixpkgs for different platforms for efficiency.
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay home-manager.overlay ];
        });

      # iso image
      iso = system:
        (nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./lib/iso-image.nix)
            (import (nixpkgs
              + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"))
            nixpkgs.nixosModules.notDetected
            (import (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix"))
            #          (import (home-manager + "/nixos") nixpkgs)
            home-manager.nixosModules.home-manager
          ];
        }).config.system.build.isoImage;

      # evals
      hosts = import ./configuration/hosts { };
      nixosHosts = nixpkgs.lib.filterAttrs (name: host: host ? hostname) hosts;
    in {
      overlay = import ./pkgs/overlay.nix;

      packages = forAllSystems
        (system: nixpkgsFor.${system} // { isoImage = (iso system); });

      nixosConfigurations = (nixpkgs.lib.mapAttrs (name: host:
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # TODO: change, for raspies and so
          modules = [
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            (import (./configuration + "/hosts/${name}/configuration.nix"))
            self.nixosModules.secrets
            self.nixosModules.ferm2
          ] ++ (if (if (host ? vm) then host.vm else false) then
            (nixpkgs.lib.singleton
              (import (nixpkgs + "/nixos/modules/profiles/qemu-guest.nix")))
          else
            [ ]) ++ (if (if (host ? mail) then host.mail else false) then
              [ ] #nixos-mailserver
            else
              [ ]);
        }).config.system.build.toplevel) nixosHosts);

      nixosModules = {
        secrets = import ./modules/secrets;
        ferm2 = import ./modules/ferm2;
      };
    };
}
