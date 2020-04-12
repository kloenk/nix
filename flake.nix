{
  name = "kloenks";

  edition = 201909;

  description = "Kloenk's Nixos configuration";

  requires = [ flake:nixpkgs/20.09 ];

  provides = deps: {
    packages.jblock = import ./pkgs { pkgs = deps.nixpkgs.packages; };
  };
}
