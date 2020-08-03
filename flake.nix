{
  description = "Kloenk's Nixos configuration";

  inputs.home-manager = {
    type = "github";
    owner = "kloenk";
    repo = "home-manager";
    ref = "flake-overlay";
    inputs.nixpkgs.follows = "/nixpkgs";
  };

  inputs.nix-darwin = {
    type = "github";
    owner = "LnL7";
    repo = "nix-darwin";
    ref = "flakes";
    inputs.nixpkgs.follows = "/nixpkgs";
  };

  inputs.nixpkgs = {
    type = "github";
    owner = "nixos";
    repo = "nixpkgs";
    #    ref = "from-unstable";
  };

  inputs.nix = {
    type = "github";
    owner = "nixos";
    repo = "nix";
    #ref = "flakes";
    inputs.nixpkgs.follows = "/nixpkgs";
  };

  inputs.hydra = {
    type = "github";
    owner = "nixos";
    repo = "hydra";
    inputs.nixpkgs.follows = "/nixpkgs";
    inputs.nix.inputs.nixpkgs.follows = "/nixpkgs";
    inputs.nix.follows = "/nix";
  };

  inputs.nixpkgs-mc = {
    type = "github";
    owner = "kloenk";
    repo = "nixpkgs";
    ref = "feature/mc-fifo";
  };

  inputs.mail-server = {
    #type = "git";
    #url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver.git";
    type = "gitlab";
    owner = "simple-nixos-mailserver";
    repo = "nixos-mailserver";
    ref = "master";
    flake = false;
  };

  inputs.website = {
    type = "git";
    url = "https://git.pbb.lc/kloenk/website.git";
    flake = false;
  };

  inputs.secrets = {
    type = "git";
    url = "git+ssh://git@git.kloenk.de/kloenk/pass.git";
    flake = false;
  };

  inputs.nixpkgs-qutebrowser = {
    type = "github";
    owner = "kloenk";
    repo = "nixpkgs-qutebrowser";
  };

  inputs.nixos-org = {
    type = "github";
    owner = "nixos";
    repo = "nixos-org-configurations";
    flake = false;
  };

  outputs = inputs@{ self, nixpkgs, nix, hydra, home-manager, nix-darwin, mail-server
    , website, secrets, nixpkgs-qutebrowser, nixpkgs-mc, nixos-org }:
    let

      overlayCombined =
        [ nix.overlay home-manager.overlay self.overlay hydra.overlay ];

      systems = [ "x86_64-linux" "x64_64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      # Memoize nixpkgs for different platforms for efficiency.
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = overlayCombined ++ [ (overlays system) ];
        });

      # patche modules
      patchModule = system: {
        _file = ./flake.nix
        disabledModules =
          [ "services/games/minecraft-server.nix" "tasks/auto-upgrade.nix" ];
        imports = [
          "${nixpkgs-mc}/nixos/modules/services/games/minecraft-server.nix"
          self.nixosModules.autoUpgrade
        ];
        nixpkgs.overlays = [ (overlays system) nix.overlay hydra.overlay ];
      };

      overlays = system: final: prev: {
        qutebrowser = nixpkgs-qutebrowser.packages.${system}.qutebrowser;
        #nixFlakes =
        #  (nix.packages.${system}.nix // { version = "2.4pre-Kloenk"; });
        #nix = (nix.packages.${system}.nix // { version = "2.4pre"; });
        #nixFlakes = final.nix.overrideAttrs (oldAttrs: rec {
        #  version = "2.4pre-kloenk";
        #});
      };

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
            home-manager.nixosModules.home-manager
            (patchModule system)
            (makeSourcesModule system)
            {
              _file = ./flake.nix;
              # disable home-manager manpage (breaks hydra see https://github.com/rycee/home-manager/issues/1262)
              home-manager.users.kloenk.manual.manpages.enable = false;
            }
          ];
        }).config.system.build.isoImage;

      # evals
      hosts = import ./configuration/hosts { };
      darwins = import ./darwin;
      nixosHosts = nixpkgs.lib.filterAttrs
        (name: host: if host ? nixos then host.nixos else false) hosts;
      makeSourcesModule = hostName:
        let
          inherit (nixpkgs) lib;
          inherit (lib) mkIf;
        in { lib, ... }: {
          _file = ./flake.nix;
          options.sources = nixpkgs.lib.mkOption { };
          config.sources = inputs;
        };

    in {
      overlay = import ./pkgs/overlay.nix;

      legacyPackages = forAllSystems
        (system: nixpkgsFor.${system} // { isoImage = (iso system); });

      packages = nixpkgs.lib.recursiveUpdate (forAllSystems (system: {
        inherit (self.legacyPackages.${system})
          isoImage home-manager redshift jblock deploy_secrets wallpapers;
      })) {
        "x86_64-linux" = {
          inherit (import ./lib/deploy.nix {
            pkgs = nixpkgsFor."x86_64-linux";
            lib = nixpkgsFor."x86_64-linux".lib;
            configurations = self.nixosConfigurations;
          })
            deploy;
        };
      };

      nixosConfigurations = (nixpkgs.lib.mapAttrs (name: host:
        (nixpkgs.lib.nixosSystem rec {
          system = host.system;
          modules = [
            { nixpkgs.overlays = [ home-manager.overlay self.overlay ]; }
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            (import (./configuration + "/hosts/${name}/configuration.nix"))
            self.nixosModules.secrets
            self.nixosModules.ferm2
            self.nixosModules.deluge2
            self.nixosModules.firefox
            (makeSourcesModule name)
            {
              _file = ./flake.nix;
              # disable home-manager manpage (breaks hydra see https://github.com/rycee/home-manager/issues/1262)
              home-manager.users.kloenk.manual.manpages.enable = false;
              #home-manager.users.pbb.manual.manpage.enable = false;
            }
            (patchModule host.system)
          ] ++ (if (if (host ? vm) then host.vm else false) then
            (nixpkgs.lib.singleton
              (import (nixpkgs + "/nixos/modules/profiles/qemu-guest.nix")))
          else
            [ ]) ++ (if (if (host ? mail) then host.mail else false) then
              [ (import (mail-server + "/default.nix")) ] # nixos-mailserver
            else
              [ ]);
        })) nixosHosts);
   
      darwinConfigurations = (nixpkgs.lib.mapAttrs (name: host: 
	nix-darwin.lib.evalConfig {
          inputs.nixpkgs = nixpkgs;
          #inputs.home-manager = home-manager;
          modules = [
          #  ({ config, ... }: { config._module.args.home-manager = home-manager; }) 
            (import (home-manager + "/nix-darwin"))
	  ];
          configuration = import (./darwin + "/hosts/${name}/configuration.nix");
        }) darwins);

      nixosModules = {
        secrets = import ./modules/secrets;
        ferm2 = import ./modules/ferm2;
        deluge2 = import ./modules/deluge.nix;
        autoUpgrade = import ./modules/upgrade;
        firefox = import ./modules/firefox;
      };

      # apps
      apps = forAllSystems (system: {
        deploy_secrets = let
          app = self.packages.${system}.deploy_secrets.override {
            passDir = toString (secrets + "/");
          };
        in {
          type = "app";
          program = "${app}";
        };
      });

      # hydra jobs
      hydraJobs = {
        isoImage.x86_64-linux = (iso "x86_64-linux");
        configurations = let lib = nixpkgs.lib;
        in lib.mapAttrs' (name: config:
          lib.nameValuePair name config.config.system.build.toplevel)
        self.nixosConfigurations;
        packages = self.packages;
      };
    };
}
