{ pkgs, lib, config, ... }:

{
  # TODO: sandbox foo

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.showhidden = true;
  
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  
  system.defaults.trackpad.Clicking = false;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  environment.variables.EDIDOR = "vim";
  environment.variables.SSH_AUTH_SOCK = "~/.gnupg/.S.gpp-agent.ssh";
  
  environment.systemPackages = with pkgs; [
    config.programs.vim.package
    # config.services.chingwm.package

    fd
    ripgrep
    curl
    fzf
    git
    gnupg
    htop
    jq
    mosh
    youtube-dl
    mpv
    #darwin-zsh-completions
    exa
  ];

  services.nix-daemon.enable = lib.mkDefault true;

  programs.nix-index.enable = true;
  

  programs.tmux = {
    #enable = true;
    enableMouse = true;
    enableFzf = true;
    enableVim = true;
  };

  programs.vim.package = pkgs.neovim.override {
    configure = {
      packages.darwin.start = with pkgs.vimPlugins; [
        vim-sensible
        rust-vim
        vim-nix
        vim-table-mode
        vim-elixir
        tabular
      ];

      customRC = ''
        set viminfo='20,<1000
        set shiftwidth=2
        "set cc=80
        set nu

        if has("autocmd")
          au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        endif
        
        if exists('$XDG_CACHE_HOME')
          let &g:directory=$XDG_CACHE_HOME
        else
          let &g:directory=$HOME . '/.cache'
        endif

        let &g:undodir=&g:directory . '/vim/undo//'
        let &g:backupdir=&g:directory . '/vim/backup//'
        let &g:directory.='/vim/swap//'
        if ! isdirectory(expand(&g:directory))
          silent! call mkdir(expand(&g:directory), 'p', 0700)
        endif
        if ! isdirectory(expand(&g:backupdir))
          silent! call mkdir(expand(&g:backupdir), 'p', 0700)
        endif
        if ! isdirectory(expand(&g:undodir))
          silent! call mkdir(expand(&g:undodir), 'p', 0700)
        endif
      '';
    };
  };

  programs.bash.enableCompletion = true;
  
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    
    promptInit = ''
      autoload -U promptinit && promptinit
    '';

    loginShellInit = ''
      function fzf-store() {
        find /nix/store -type d -mindepth 1 -maxdepth 1 | fzf -m --preview-window --right:50% --preview 'nix-store -q --tree {}'
      }
      function ls {
       ${pkgs.exa}/bin/exa --color=auto "$@" 
      }
      function ll {
       ${pkgs.exa}/bin/exa --color=auto -l "$@"
      }
      function lt {
       ${pkgs.exa}/bin/exa --color=auto -lT "$@"
      }
      function otool() {
        ${pkgs.darwin.cctools}/bin/otool "$@"
      }

      function use {
        packages=()
        while [ "$#" -gt 0 ]; do
          i="$1"; shift 1
          packages_fmt+=$(echo $i | ${pkgs.gnused}/bin/sed 's/[a-zA-Z]*#//')
          [[ $i =~ [a-zA-Z]#[a-zA-Z]* ]] || i="kloenk#$i"
          packages+=$i
        done
        env prompt_sub="%F{blue}($packages_fmt) %F{white}$PROMPT" nix shell $packages
      }
      PROMPT=''${prompt_sub:=$PROMPT}
    '';
  };

  environment.extraInit = ''
    if [ -d /etc/environment.d ]; then
      set -a
      . /etc/environment.d*
      set +a
    f
  '';

}
