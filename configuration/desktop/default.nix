{ config, pkgs, lib, ... }:

let
  jblock = <sources/jblock>;
in {
  home-manager.useUserPackages = true;

  users.users.kloenk.packages = with pkgs; [
    flameshot
    rustup
    gcc
    yarn
    nodejs-10_x
    python3

    gnupg
    powertop
    qemu
    imagemagick
    gimp
    inkscape
    krita
    sshfs
    quasselClient
    pavucontrol
    gnupg
    mpv
    tdesktop
    evince
    youtubeDL
    calcurse
    neomutt
    bind # for dig
    screen # for usb serial
    pass-otp
    mosh
    libreoffice
    blueman
    mkpasswd
    lxappearance-gtk3
    dino
    spotify-tui

    onefetch

    # java
    jre8_headless

    # Archives (e.g., tar.gz and zip)
    ark

    # mail
    thunderbird

    # picture viewving
    sxiv
    feh
    rofi-pass
    xclip
    xorg.xmodmap
    

    # audio
    audacity

    # KiCad pcb layout tool
    #kicad
    openscad

    # vs code (mit license)
    vscodium

    # web browser
    firefox
    qutebrowser
  ];


  users.users.kloenk.extraGroups = [ "wireshark" "adbusers" "nitrokey" ];
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark-qt;
  nixpkgs.config.android_sdk.accept_license = true;
  programs.adb.enable = true;
  programs.chromium = { enable = true; extensions = [
      "cfhdojbkjhnklbpkdaibdccddilifddb" # ad block plus
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # gramarly
      "ppmmlchacdbknfphdeafcbmklcghghmd" # jwt debugger
      "laookkfknpbbblfpciffpaejjkokdgca" # momentum
      "pdiebiamhaleloakpcgmpnenggpjbcbm" # tab snooze
    ];
  };
  hardware.nitrokey.enable = true;

  # steam hardware
  hardware.steam-hardware.enable = true;
  hardware.opengl.driSupport32Bit = true;

  home-manager.users.kloenk.programs.git.signing = {
        key = "0xC9546F9D";
        signByDefault = true;
  };


  home-manager.users.kloenk.home.file.".config/VSCodium/User/settings.json".source = ./code-settings.json;
  home-manager.users.kloenk.home.file.".config/qutebrowser/config.py".text = ''
    config.bind('p', 'spawn --userscript qute-pass --dmenu-invocation "wofi --show dmenu"')
    config.bind('P', 'spawn --userscript qute-pass --otp-only --dmenu-invocation "wofi --show dmenu"')
    config.bind('m', 'spawn mpv {url}')
    config.bind('M', 'hint links spawn mpv {hint-url}')

    c.content.host_blocking.enabled = False
    c.content.host_blocking.lists = [
      'https://easylist.to/easylist/easylist.txt',
      'https://easylist.to/easylist/easyprivacy.txt'
    ]

    import sys, os
    sys.path.append(os.path.join(sys.path[0], '${jblock}'))
    config.source("${jblock}/jblock/integrations/qutebrowser.py")
  '';

  home-manager.users.kloenk.home.packages = [ pkgs.kitty ];
  home-manager.users.kloenk.xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;

    # extra codes for pulseaudio bluetooth
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };
  nixpkgs.config.pulseaudio = true;
}
