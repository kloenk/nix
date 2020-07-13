{ stdenv, fetchFromGitHub, libnfc, pam, autoconf, automake, libtool, m4, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pam_nfc-${version}";
  version = "master";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = "pam_nfc";
    rev = "bb762e0e649195110e015ffb605c4375e927c437";
    sha256 = "sha256-7SN3llrebVYyA4hAegwAsJfA4FrOLC3liMMZg8Ogl3M=";
  };

  nativeBuildInputs = [ autoconf automake libtool m4 pkgconfig ];
  buildInputs = [ libnfc pam ];

  preBuild = "make $makeFlags libnfcauth.la";

  preConfigure = ''
    pkg-config --modversion libnfc

    autoreconf -fvi
  '';

}
