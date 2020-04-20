{ lib, pkgs, config, ... }:

{
  home-manager.users.kloenk.programs.zsh = {
    initExtra = ''
      function use {
        packages=()
        packages_fmt=()
        while [ "$#" -gt 0 ]; do
          i="$1"; shift 1
          packages_fmt+=$(echo $i | ${pkgs.gnused}/bin/sed 's/[a-zA-Z]*#//')
          [[ $i =~ [a-zA-Z]*#[a-zA-Z]* ]] || i="kloenk#$i"
          packages+=$i
        done
        env prompt_sub="%F{blue}($packages_fmt) %F{white}$PROMPT" nix run $packages -c zsh
      }
      PROMPT=''${prompt_sub:=$PROMPT}
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
        "cargo"
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
      l = "exa -a";
      ll = "exa -lgh";
      la = "exa -lagh";
      lt = "exa -T";
      lg = "exa -lagh --git";
    };
  };
}
