{ pkgs, lib, ... }:

{
  programs = {
    git = {
      enable = true;
      userName = "Finn Behrens";
      userEmail = "me@kloenk.de";
      aliases.master = "checkout master";
      aliases.ls = "status";
      extraConfig = {
          color.ui = true;
        };
      };

      ssh = {
        enable = true;
        forwardAgent = false;
        controlMaster = "auto";
        controlPersist = "15m";
        matchBlocks = {
          hubble = {
            hostname = "hubble.kloenk.de";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          hubble-encrypt = {
            hostname = "51.254.249.187";
            port = 62954;
            user = "root";
            forwardAgent = false;
            checkHostIP = false;
            extraOptions = { "UserKnownHostsFile" = "/dev/null"; };
          };
          lycus = {
            hostname = "10.0.0.5";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          lycus-pbb = {
            hostname = "10.0.0.5";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
            proxyJump = "io-pbb";
          };
          admin-yougen = {
            hostname = "10.66.6.42";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          admin-yougen-io = {
            hostname = "10.66.6.42";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
            proxyJump = "io-llg0";
          };
          pluto = {
            hostname = "10.0.0.3";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          pluto-io = {
            hostname = "10.0.0.3";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
            proxyJump = "io-llg0";
          };
          io = {
            hostname = "10.0.0.2";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          io-llg0 = {
            hostname = "192.168.43.2";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          io-pbb = {
            hostname = "195.39.247.9";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          atom = {
            hostname = "192.168.178.248";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          atom-wg = {
            hostname = "atom.kloenk.de";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          gurke = {
            hostname = "gurke.pbb.lc";
            port = 62954;
            user = "kloenk";
          };
          polyus = {
            hostname = "polyus.kloenk.de";
            port = 62954;
            user = "kloenk";
          };

          # nyantec
          "berlin.nyantec.com" = {
            hostname = "berlin.nyantec.com";
            port = 24;
            user = "fin";
            forwardAgent = true;
          };

          # gdv
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
        };
      };

      vim = {
        enable = true;
        settings = {
          tabstop = 2;
        };
        extraConfig = ''
          set viminfo='20,<1000
          set shiftwidth=2
          set cc=80
          set nu
        '';
        plugins = with pkgs; [ vimPlugins.rust-vim vimPlugins.tabular  vimPlugins.vim-nix vimPlugins.vim-table-mode ];
      };
    };

    services = {
      gpg-agent = {
        enable = true;
        defaultCacheTtl = 300; # 5 min
        defaultCacheTtlSsh = 600; # 10 min
        maxCacheTtl = 7200; # 2h
        pinentryFlavor = "gtk2";
      };
    };
  }
