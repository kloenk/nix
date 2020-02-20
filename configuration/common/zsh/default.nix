{ lib, pkgs, config, ... }:

{
  home-manager.users.kloenk.programs.zsh = {
    initExtra = ''
      function use {
        nix-shell -p $@ --run zsh
      }
    '';
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    localVariables = config.environment.variables;
    oh-my-zsh = {
      enable = true;
      theme = "fishy";
      plugins = [
        #"git"
        "sudo"
        "ripgrep"
      ];
    };
    plugins = [
      # {
      #   name = "zsh-fast-syntax-highlighting";
      #   src = pkgs.zsh-fast-syntax-highlighting;
      # }
       {
         name = "zsh-syntax-highlighting";
         src = pkgs.zsh-syntax-highlighting;
       }
    ];
    shellAliases = {
      ls = "exa";
      l  = "exa -a";
      ll = "exa -lgh";
      la = "exa -lagh";
      lt = "exa -T";
      lg = "exa -lagh --git";
    };
  };
}
