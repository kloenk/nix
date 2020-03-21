{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules
    ./nginx
    ./node-exporter
    ./zsh
  ];

  nixpkgs.overlays = [
    (self: super: import ../../pkgs { pkgs = super; })
  ];

  environment.etc."src/nixpkgs".source = config.sources.nixpkgs;
  environment.etc."src/nixos-config".text = ''
      ((import (fetchTarball "https://github.com/kloenk/nix/archive/master.tar.gz") { }).configs.${config.networking.hostName})
  '';
  environment.variables.NIX_PATH = lib.mkOverride 25 "/etc/src";

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

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "neo";
  console.font = "Lat2-Terminus16";

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    termite.terminfo
    kitty.terminfo
    alacritty.terminfo
    rxvt_unicode.terminfo
    restic
    tmux
    exa
    iptables
    bash-completion
    whois
    qt5.qtwayland
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBps9Mp/xZax8/y9fW1Gt73SkskcBux1jDAB8rv0EYUt cardno:000611120054"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEDZjcKdYViw9cPrLNkO37+1NgUj8Ul1PTlbXMMwlMR kloenk@kloenkX"
    ];
    packages = with pkgs; [
      wget
      #vim
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
                        #git
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

  home-manager.users.kloenk = import ./home.nix { pkgs = pkgs; lib = lib; };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  #programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.mtr.enable = true;

  #users.users.root.shell = pkgs.fish;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISCKsWIhN2UBenk0kJ1Hnc+fCZC/94l6bX9C4KFyKZN cardno:FFFE43212945"
  ];
}
