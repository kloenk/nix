{ stdenv, fetchurl, jre_headless, minecraft-server }:
stdenv.mkDerivation rec {
  pname = "fabric-server";
  version = "1.15.2";
  src = fetchurl {
    url =
      "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.5.2.39/fabric-installer-0.5.2.39.jar";
    sha256 = "c87da229c1c1be8b7ddefa1cbbc322431cbc22d0b44205bb9ee0ebce5f041678";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/fabric
    ln -s ${minecraft-server}/lib/minecraft/server.jar $out/lib/fabric/server.jar

    ${jre_headless}/bin/java -jar $src server -mcversion ${version} -dir $out/lib/fabric/ 

    cat > $out/bin/minecraft-server << EOF
      #!/bin/sh
      exec ${jre_headless}/bin/java \$@ -jar $out/lib/minecraft/server.jar nogui
    EOF
    chmod +x $out/bin/minecraft-server
  '';

  phases = "installPhase";
}
