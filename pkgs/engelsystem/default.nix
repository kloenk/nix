{
  stdenv
, fetchzip
}:

let

in
 stdenv.mkDerivation rec {
  pname = "engelsystem";
  version = "3.1.0";

  src = fetchzip {
    url = "https://github.com/engelsystem/engelsystem/releases/download/v3.1.0/engelsystem-v3.1.0.zip";
    sha256 = "01wra7li7n5kn1l6xkrmw4vlvvyqh089zs43qzn98hj0mw8gw7ai";
    extraPostFetch = "chmod -R a-w $out";
  };

  installPhase = ''
    runHook preInstall

    # prepare
    rm -r ./storage/
    ln -sf /etc/engelsystem/config.php ./config/config.php
    ln -sf /var/lib/engelsystem/ ./storage

    mkdir -p $out/share/engelsystem
    cp -r . $out/share/engelsystem
  '';

  meta = with stdenv.lib; {
    description = "Coordinate your helpers in teams, assign them to work shifts or let them decide for themselves when and where they want to help with what";
    #license = license.gpl2;
    homepage = "https://engelsystem.de";
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
