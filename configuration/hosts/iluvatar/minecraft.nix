{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "minecraft-20w20a"
    "minecraft-server"
  ];

  services.minecraft-server = {
    enable = true;
    dataDir = "/persist/data/minecraft/eljoy";
    declarative = true;
    eula = true;
    package = pkgs.minecraft-20w20a;
    serverProperties = {
      server-port = 25565;
      max-players = 20;
      motd = builtins.trace "TODO: set motd for minecraft" "please provide a motd for me";
      difficulty = "normal";
      force-gamemode = true;
      #"rcon.password"
    };
  };
}
