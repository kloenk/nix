{
  config
, pkgs
, lib
, ...}:

in
  grubDev = "/dev/sda";
  interface = "eno0";
  hostname = "nixos";
  supportedFilesystems = [ ];
let {
    imports = [
        ./hardware-configuration.nix
        (builtins.fetchGit {
          url = "https://github.com/rycee/home-manager/";
          rev = "d677556e62ab524cb6fcbc20b8b1fb32964db021";
          #sha256 = "17kdp4vflyvqiq1phy7x5mfrcgy5c02c0a0p0n5yjf8yilvcldr4";
        } + "/nixos")
    ];

    boot.loader.grub = {
        enable = true;
        version = 2;
        device = grubDev;
        useOSProber = true;
    };

    boot.supportedFilesystems = [ "xfs" ] ++ supportedFilesystems;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = hostname;
    networking.useDHCP = false;
    networking.interfaces."${interface}".useDHCP = true;

    services.openssh = {
      enable = true;
      ports = [ 62954 ];
      passwordAuthentication = false;
      permitRootLogin = "without-password";
    };

    security.sudo.wheelNeedsPassword = false;

    i18n = {
      Font = "Lat2-Terminus16";
      KeyMap = "neo";
      defaultLocale = "en_US.UTF-8";
    };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    termite.terminfo
    kitty.terminfo
    tmux
    exa
    vim
    bat
    file
  ];

  environment.variables.EDITOR = "vim";

  users.users.kloenk = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISCKsWIhN2UBenk0kJ1Hnc+fCZC/94l6bX9C4KFyKZN cardno:FFFE43212945"
    ];
    packages = with pkgs; [
      wget
      nload
      htop
      ripgrep
      git
      gptfdisk
      nix-prefetch-git
      pass
      pass-otp
      gopass
      sl
      neofetch
    ];
  };

  # TODO home-manager-dir
  # TODO krops dir/file
  system.activationScripts = {
    base-dirs = {
      text = ''
        mkdir -p /nix/var/nix/profiles/per-user/kloenk
        mkdir -p /var/src
        touch /var/src/.populate
      '';
      deps = [];
    };
  };

  home-manager.users.kloenk = {
    programs = {
      git = {
        enable = true;
        userName = "Finn Behrens";
        userEmail = "me@kloenk.de";
        extraConfig = {
          core.editor = "${pkgs.vim}/bin/vim";
          color.ui = true;
        };
      };

      fish = {
        enable = true;
        shellInit = ''
          set PAGER less
        '';
        shellAbbrs = {
          admin-YouGen = "ssh admin-yougen";
          cb = "cargo build";
          cr = "cargo run";
          ct = "cargo test";
          exit = " exit";
          gc = "git commit";
          gis = "git status";
          gp = "git push";
          hubble = "mosh hubble";
          ipa = "ip a";
          ipr = "ip r";
          s = "sudo";
          ssy = "sudo systemctl";
          sy = "systemctl";
          v = "vim";
          jrnl = " jrnl";
        };
        shellAliases = {
          ls = "exa";
          l = "exa -a";
          ll = "exa -lgh";
          la = "exa -lagh";
          lt = "exa -T";
          lg = "exa -lagh --git";
        };
      };

      ssh = {
        enable = true;
        forwardAgent = false;
        controlMaster = "auto";
        controlPersist = "15m";
        matchBlocks = {
          hubble = {
            hostname = "kloenk.de";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          hubble-encrypt = {
            hostname = "51.254.249.187";
            port = 62954;
            user = "root";
            forwardAgent = false;
            #identityFile = toString <secrets/id_rsa>;
            checkHostIP = false;
            extraOptions = { "UserKnownHostsFile" = "/dev/null"; };
          };
          lycus = {
            hostname = "10.0.0.4";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
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
          atom = {
            hostname = "192.168.178.248";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          atom-wg = {
            hostname = "192.168.42.7";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          kloenkX-fritz = {
            hostname = "192.168.178.43";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
        };
      };

      vim = {
        enable = true;
      };
    };

    services = {
      gpg-agent = {
        enable = true;
        defaultCacheTtl = 300; # 5 min
        defaultCacheTtlSsh = 600; # 10 min
        maxCacheTtl = 7200; # 2h
      };
    };
  };
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };

  programs.fish.enable = true;
  programs.mtr.enable = true;

  users.users.root.shell = pkgs.fish;

  system.stateVersion = "20.03";
}
