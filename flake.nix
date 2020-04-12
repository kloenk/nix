{
  name = "kloenks";

  edition = 202009;

  description = "Kloenk's Nixos configuration";

  requires = [ flake:nixpkgs/20.09 ];

  provides = deps: {
    packages.jblock = import ./pkgs { pkgs = deps.nixpkgs.packages; };
  };
}
