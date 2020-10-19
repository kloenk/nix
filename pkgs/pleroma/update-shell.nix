with import <nixpkgs> { overlays = [ (self: super: import ../. { }) ]; };

stdenv.mkDerivation {
  name = "shell";
  buildInputs = [ nix-prefetch-scripts rsync mixnix.mix2nix nix jq ];
}
