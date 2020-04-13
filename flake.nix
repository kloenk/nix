{
  edition = 201909;

  description = "Kloenk's Nixos configuration";

  inputs.home-manager = {
    type = "github";
#    owner = "rycee";
    owner = "eadwu";
    repo = "home-manager";
#    flake = false;
  };

  inputs.home-manager.inputs.nixpkgs.follows = "/nixpkgs";

  outputs = inputs@{ self, nixpkgs, home-manager }: let

    systems = [ "x86_64-linux" ];

    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

     # Memoize nixpkgs for different platforms for efficiency.
     nixpkgsFor = forAllSystems (system:
     import nixpkgs {
       inherit system;
       overlays = [ self.overlay ];
     });

     # iso image
     iso = system:
       (nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (import ./lib/iso-image.nix)
          (import (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"))
          nixpkgs.nixosModules.notDetected
          (import (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix"))
          (import (home-manager + "/nixos") nixpkgs)
#          home-manager.nixosModules.home-manager
        ];
      }).config.system.build.isoImage;

  in{
    overlay = import ./pkgs/overlay.nix;

    packages = forAllSystems ( system:
      nixpkgsFor.${system} //
      {
        isoImage = (iso system);
      }
    );
  };
}
