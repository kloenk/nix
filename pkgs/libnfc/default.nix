{ stdenv, fetchFromGitHub, libusb-compat-0_1, readline, autoconf, automake
, libtool, m4, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libnfc";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = "libnfc";
    rev = "libnfc-${version}";
    sha256 = "sha256-pfdUQnoeSoakXDBmz9GWs5JpqRd43lJnoftIoCoEptw=";
  };

  buildInputs =
    [ libusb-compat-0_1 readline autoconf automake libtool m4 pkgconfig ];

  preConfigure = ''
    autoreconf -vis
  '';

  meta = with stdenv.lib; {
    description = "Open source library libnfc for Near Field Communication";
    license = licenses.gpl3;
    homepage = "https://github.com/nfc-tools/libnfc";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
