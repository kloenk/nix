{ lib, pkgs, config, ... }:

{
  nix.registry.kloenk = {
    from.type = "indirect";
    from.id = "kloenk";
    to.owner = "kloenk";
    to.repo = "nix";
    to.type = "github";
  };

  users.users.kloenk = {
    isNormalUser = true;
    uid = lib.mkDefault 1000;
    initialPassword = lib.mkDefault "foobar";
    extraGroups = [ "wheel" "bluetooth" "libvirt" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBps9Mp/xZax8/y9fW1Gt73SkskcBux1jDAB8rv0EYUt cardno:000611120054"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEDZjcKdYViw9cPrLNkO37+1NgUj8Ul1PTlbXMMwlMR kloenk@kloenkX"
    ];
    packages = with pkgs; [
      wget
      tmux
      nload
      htop
      ripgrep
      exa
      bat
      progress
      pv
      file
      elinks
      bc
      #zstd
      unzip
      jq
      gopass
      neofetch
      onefetch
      sl
      tcpdump
      binutils
      nixfmt
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.ssh.knownHosts = {
    "kloenk.de" = {
      hostNames = [ "*.kloenk.de" ];
      certAuthority = true;
      publicKeyFile = toString ./server_ca.pub;
    };
  };
}
