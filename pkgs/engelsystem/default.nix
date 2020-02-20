{
	stdenv
, fetchurl
, writeText
, pkgs
}:

let

in
 stdenv.mkDerivation rec {
  pname = "engelsystem";
  version = "unstable-2020-02-10"; # ??????

  src = fetchGit {
  	url = "https://github.com/engelsystem/engelsystem.git";
    rev = "d6ff7b58161d80959a0880f0ddb37e3cf5ee91a0";
  };

  buildInputs = with pkgs; [ gettext yarn ];

  phpConfig = writeText "config.php" ''
    <?php
      return require(getenv('ES_CONFIG'));
    ?>
  '';

  installPhase = ''
    runHook preInstall

    find . -type f -name '*.po' -exec sh -c 'file="{}"; msgfmt "\$\{file%.*}.po" -o "\$\{file%.*}.mo"' \;

    mkdir -p $out/share/engelsystem
    cp -r . $out/share/engelsystem
    cp ${phpConfig} $out/share/engelsystem/config/config.php
  '';

  meta = with stdenv.lib; {
  	description = "Coordinate your helpers in teams, assign them to work shifts or let them decide for themselves when and where they want to help with what";
  	license = license.gpl2;
  	homepage = "https://engelsystem.de";
  	maintainers = with maintainers; [ ];
  	platforms = platforms.all;
  };
}