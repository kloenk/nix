{ pkgs, lib, ... }:

let
  hosts = import ../hosts { };
  sshHosts = lib.filterAttrs (name: host: host ? host) hosts;

  genMatchBlocks = (lib.mapAttrs' (name: host:
    lib.nameValuePair name {
      hostname = host.host.ip;
      port = host.host.port;
      forwardAgent =
        (if host ? noForwardAgent then !host.noForwardAgent else true);
      user = host.host.user;
      extraOptions =
        (if host.host ? sshConfig then host.host.sshConfig else { });
    }) sshHosts);

in {
  programs = {
    git = {
      enable = true;
      userName = "Finn Behrens";
      userEmail = "me@kloenk.de";
      aliases.master = "checkout master";
      aliases.ls = "status";
      extraConfig = { color.ui = true; };
    };

    ssh = {
      enable = true;
      forwardAgent = false;
      controlMaster = "auto";
      controlPersist = "15m";
      matchBlocks = genMatchBlocks // {
        lycus = {
          hostname = "10.0.0.5";
          port = 62954;
          user = "kloenk";
          forwardAgent = true;
        };
        # nyantec
        "berlin.nyantec.com" = {
          hostname = "berlin.nyantec.com";
          port = 24;
          user = "fin";
          forwardAgent = true;
        };
        "*.nyantec.com" = {
          user = "fin";
          forwardAgent = true;
        };
        "airlink.one" = {
          user = "fin";
        };

        "*.petabyte.dev" = {
          port = 62954;
        };
        "*.pbb.lc" = {
          port = 62954;
        };

        /* # gdv
           gdv01 = {
             hostname = "gdv01.eventphone.de";
             port = 22;
             user = "root";
           };
           gdv02 = {
             hostname = "gdv02.eventphone.de";
             port = 22;
             user = "root";
           };
        */
      };
    };

    vim = {
      enable = true;
      settings = { tabstop = 2; };
      extraConfig = ''
        set viminfo='20,<1000
        set shiftwidth=2
        "set cc=80
        set nu

        " Uncomment the following to have Vim jump to the last position when
        " reopening a file
        if has("autocmd")
          au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        endif

        " Move temporary files to a secure location to protect against CVE-2017-1000382
        if exists('$XDG_CACHE_HOME')
          let &g:directory=$XDG_CACHE_HOME
        else
          let &g:directory=$HOME . '/.cache'
        endif

        let &g:undodir=&g:directory . '/vim/undo//'
        let &g:backupdir=&g:directory . '/vim/backup//'
        let &g:directory.='/vim/swap//'
        " Create directories if they doesn't exist
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
      plugins = with pkgs.vimPlugins; [
        rust-vim
        tabular
        vim-nix
        vim-table-mode
        vim-elixir

        #nerdtree
        #nerdtree-git-plugin
      ];
    };
  };

  services = {
    gpg-agent = {
      enable = lib.mkDefault true;
      defaultCacheTtl = 300; # 5 min
      defaultCacheTtlSsh = 600; # 10 min
      maxCacheTtl = 7200; # 2h
      pinentryFlavor = "gtk2";
    };
  };
}
