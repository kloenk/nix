{
  edition = 201909;

  description = "Kloenk's Nixos configuration";

  outputs = { self, nixpkgs }: let 
    systems = [ "x86_64-linux" ];

    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

     # Memoize nixpkgs for different platforms for efficiency.
     nixpkgsFor = forAllSystems (system:
     import nixpkgs {
       inherit system;
       #overlays = [ self.overlay ];
     });
  in{
    packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgsFor.${system}; lib = nixpkgs.lib; });
  };
}
