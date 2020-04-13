{ pkgs, lib, ... }:

{
  #inherit (import ../../common/zsh {lib = lib; pkgs = pkgs; config = {}; } ) home-manager.users.kloenk;
  programs = (import ../../common/zsh {
    lib = lib;
    pkgs = pkgs;
    config = { environment.variables = { }; };
  }).home-manager.users.kloenk.programs;
}
