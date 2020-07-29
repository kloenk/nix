{ config, pkgs, lib, ... }:

{

  imports = [
    ./firefox.nix
  ];

  home-manager.useUserPackages = true;

  security.rngd.enable = lib.mkDefault false;

  environment.systemPackages = with pkgs; [ qt5.qtwayland ];

  users.users.kloenk.packages = with pkgs; [
    flameshot
    grim
    rustup
    gcc
    yarn
    nodejs-10_x
    python3

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
    #libreoffice
    blueman
    mkpasswd
    lxappearance
    dino
    spotify-tui
    xonotic

    onefetch

    # java
    jdk
    gradle
    (jetbrains.idea-community.override { jdk = jdk; })

    # elixir
    elixir

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
    #vscodium
    atom
    gvfs
    gnome3.nautilus # Dependency for atom?

    notable

    # web browser
    #firefox-wayland
    firefox-policies-wrapped
    qutebrowser
    chromium
    #config.sources.nixpkgs-qutebrowser.packages."x86_64-linux".qutebrowser
  ];

  users.users.kloenk.extraGroups = [ "wireshark" "adbusers" "nitrokey" ];

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark-qt;
  nixpkgs.config.android_sdk.accept_license = true;
  programs.adb.enable = true;

  programs.gnupg.agent.enable = true;

  programs.browserpass.enable = true;
  programs.chromium = {
    enable = true;
    extensions = [
      "cfhdojbkjhnklbpkdaibdccddilifddb" # ad block plus
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # gramarly
      "ppmmlchacdbknfphdeafcbmklcghghmd" # jwt debugger
      "laookkfknpbbblfpciffpaejjkokdgca" # momentum
      "pdiebiamhaleloakpcgmpnenggpjbcbm" # tab snooze
      "naepdomgkenhinolocfifgehidddafch" # browserpass
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "hjdoplcnndgiblooccencgcggcoihigg" # terms of services didn't read
    ];
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    extraOpts = {
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "duckduckgo";
      PasswordManagerEnabled = false;
    };
  };

  nixpkgs.config.chromium = { enableWideVine = true; };

  hardware.nitrokey.enable = true;

  # steam hardware
  hardware.steam-hardware.enable = true;
  hardware.opengl.driSupport32Bit = true;

  home-manager.users.kloenk.programs.git.signing = {
    key = "0x8609A7B519E5E342";
    signByDefault = true;
  };
  home-manager.users.kloenk.services.gpg-agent.enable = true;

  home-manager.users.kloenk.home.file.".config/VSCodium/User/settings.json".source =
    ./code-settings.json;
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
    sys.path.append(os.path.join(sys.path[0], '${pkgs.jblock}'))
    config.source("${pkgs.jblock}/jblock/integrations/qutebrowser.py")
  '';

  home-manager.users.kloenk.home.packages = [ pkgs.kitty ];
  home-manager.users.kloenk.xdg.configFile."kitty/kitty.conf".source =
    ./kitty.conf;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = lib.mkDefault true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = lib.mkDefault pkgs.pulseaudioFull;

    # extra codes for pulseaudio bluetooth
    extraModules = [ pkgs.pulseaudio-modules-bt ];

    # allow other servers
    tcp.enable = true;
    tcp.anonymousClients.allowedIpRanges = [
      "195.39.246.0/24"
      "2a0f:4ac0::/64"
      "2a0f:4ac0:f199::/48"
      "2a0f:4ac0:40::/44"
    ];
  };
  nixpkgs.config.pulseaudio = true;
}
