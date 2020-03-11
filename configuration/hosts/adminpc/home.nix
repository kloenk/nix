{ pkgs, ... }:

{
  imports = [
    ../../common/home.nix
    ../../manager/ext/sway.nix
    ../../manager/ext/zsh.nix
  ];
  home.packages = [ pkgs.sway ];
}
