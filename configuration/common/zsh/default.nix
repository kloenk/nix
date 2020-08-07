{ lib, pkgs, config, ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [ fzf ];

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
        env prompt_sub="%F{blue}($packages_fmt) %F{white}$PROMPT" nix shell $packages
      }
      PROMPT=''${prompt_sub:=$PROMPT}

      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh

      fzf-store() {
        find /nix/store -maxdepth 1 -mindepth 1 -type d  | fzf -m --preview-window right:50% --preview 'nix-store -q --tree {}'
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
