{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "minecraft-20w20a" "minecraft-server" ];

  services.minecraft-server = {
    enable = true;
    dataDir = "/persist/data/minecraft/eljoy";
    declarative = true;
    eula = true;
    package = pkgs.minecraft-20w20a;
    serverProperties = {
      server-port = 25565;
      max-players = 20;
      motd = builtins.trace "TODO: set motd for minecraft"
        "please provide a motd for me";
      difficulty = "normal";
      force-gamemode = true;
      white-list = true;
      #"rcon.password"
    };
    whitelist = {
      kloenk = "c16d92b1-eca1-4387-93de-4f27de56ff03";
      Drachensegler = "7698b19e-6cb9-4ce1-9a16-3f578263eea3";
      Ennsn456 = "812e9708-f096-41bc-a64d-9251c211dd32";
    };
  };

  systemd.services.minecraft-server.serviceConfig.StandardInput = "socket";
  systemd.services.minecraft-server.serviceConfig.StandardOutput = "journal";

  systemd.sockets.minecraft-server = {
    description = "controll process for the minecraft server";
    socketConfig.ListenFIFO = "/run/minecraft/stdin";
    wantedBy = [ "sockets.target" ];
  };
}
