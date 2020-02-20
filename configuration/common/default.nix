{ config, pkgs, lib, ... }:

{
  imports = [
    <modules>
    <sources/home-manager/nixos>
    ./nginx
    ./node-exporter
    ./zsh
  ];

  nixpkgs.overlays = [
    (self: super: import <pkgs> { pkgs = super; })
  ];

  environment.variables.NIX_PATH = lib.mkOverride 25 "/var/src";

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  nix.gc.automatic = lib.mkDefault true;
  nix.gc.options = lib.mkDefault "--delete-older-than 7d";
  nix.trustedUsers = [ "root" "@wheel" "kloenk" ];

  networking.useNetworkd = lib.mkDefault true;

  services.openssh.enable = true;
  services.openssh.ports = [ 62954 ];
  services.openssh.passwordAuthentication = lib.mkDefault false;
  services.openssh.challengeResponseAuthentication = false;
  services.openssh.permitRootLogin = lib.mkDefault "no";
  services.vnstat.enable = lib.mkDefault true;
  security.sudo.wheelNeedsPassword = false;

  services.ferm2.enable = true;
  services.ferm2.forwardPolicy = lib.mkDefault "DROP";

  services.journald.extraConfig = "SystemMaxUse=2G";

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  console.keyMap = "neo";
  console.font = "Lat2-Terminus16";

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    termite.terminfo
    kitty.terminfo
    rxvt_unicode.terminfo
    restic
    tmux
    exa
    iptables
    bash-completion
  ];

  environment.variables.EDITOR = "vim";

  users.users.kloenk = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "bluetooth"
      "libvirt"
    ];
   shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISCKsWIhN2UBenk0kJ1Hnc+fCZC/94l6bX9C4KFyKZN cardno:FFFE43212945"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEDZjcKdYViw9cPrLNkO37+1NgUj8Ul1PTlbXMMwlMR kloenk@kloenkX"
    ];
    packages = with pkgs; [
      wget
      vim
      tmux
      nload
      htop
      rsync
      ripgrep
      exa
      bat
      progress
      pv
      parallel
      skim
      file
      git
      elinks
      bc
      zstd
      usbutils
      pciutils
      mediainfo
      ffmpeg_4
      mktorrent
      unzip
      gptfdisk
      jq
      nix-prefetch-git
      pass-otp
      gopass
      neofetch
      sl
      todo-txt-cli
      tcpdump
      binutils
    ];
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

      #fish = {
      #  enable = true;
      #  shellInit = ''
      #    set PAGER less
      #  '';
      #  shellAbbrs = {
      #    admin-YouGen = "ssh admin-yougen";
      #    cb = "cargo build";
      #    cr = "cargo run";
      #    ct = "cargo test";
      #    exit = " exit";
      #    gc = "git commit";
      #    gis = "git status";
      #    gp = "git push";
      #    hubble = "mosh hubble";
      #    ipa = "ip a";
      #    ipr = "ip r";
      #    s = "sudo";
      #    ssy = "sudo systemctl";
      #    sy = "systemctl";
      #    v = "vim";
      #    jrnl = " jrnl";
      #  };
      #  shellAliases = {
      #    ls = "exa";
      #    l = "exa -a";
      #    ll = "exa -lgh";
      #    la = "exa -lagh";
      #    lt = "exa -T";
      #    lg = "exa -lagh --git";
      #  };
      #};

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
        pinentryFlavor = "gtk2";
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  #programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.mtr.enable = true;

  #users.users.root.shell = pkgs.fish;
}
