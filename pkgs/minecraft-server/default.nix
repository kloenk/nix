{ stdenv, fetchurl, jre }:

# copied from nixpkgs from the maintainers thoughtpolice, tomberek and costrouc

let
  common = { version, sha256, url }:
    stdenv.mkDerivation (rec {
      name = "minecraft-server-${version}";
      inherit version;

      src = fetchurl {
        inherit url sha256;
      };

      preferLocalBuild = true;

      installPhase = ''
        mkdir -p $out/bin $out/lib/minecraft
        cp -v $src $out/lib/minecraft/server.jar
        cat > $out/bin/minecraft-server << EOF
        #!/bin/sh
        exec ${jre}/bin/java \$@ -jar $out/lib/minecraft/server.jar nogui
        EOF
        chmod +x $out/bin/minecraft-server
      '';

      phases = "installPhase";

      meta = {
        description = "Minecraft Server";
        homepage    = "https://minecraft.net";
        license     = stdenv.lib.licenses.unfreeRedistributable;
        platforms   = stdenv.lib.platforms.unix;
      };
    });

in {
  minecraft-server_1_14_2 = common {
      version = "1.14.2";
      url = "https://launcher.mojang.com/v1/objects/808be3869e2ca6b62378f9f4b33c946621620019/server.jar";
      sha256 = "b47fd85155ae77c2bc59e62a215310c4dce87c7dfdf7588385973fa20ff4655b";
  };
}
