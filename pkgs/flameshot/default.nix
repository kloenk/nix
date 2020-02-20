{ stdenv, fetchFromGitHub, qtbase, qmake, qttools, qtsvg }:

# To use `flameshot gui`, you will also need to put flameshot in `services.dbus.packages`
# in configuration.nix so that the daemon gets launched properly:
#
#   services.dbus.packages = [ pkgs.flameshot ];
#   environment.systemPackages = [ pkgs.flameshot ];
stdenv.mkDerivation rec {
  name = "flameshot-${version}";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "kloenk";
    repo = "flameshot";
    rev = "e530145927bd936c56935bd26df85789cfef21f0";
    sha256 = "0fqy8zask9d6vgyhp3qgm3pjfwa4yavnhj7pa7f1iqniiqdhg5k1";
  };

  nativeBuildInputs = [ qmake qttools qtsvg ];
  buildInputs = [ qtbase ];

  qmakeFlags = [ "PREFIX=${placeholder "out"}" ];

  preConfigure = ''
    # flameshot.pro assumes qmake is being run in a git checkout.
    git() { echo ${version}; }
    export -f git
  '';

  postFixup = ''
    substituteInPlace $out/share/dbus-1/services/org.dharkael.Flameshot.service \
      --replace "/usr/local" "$out"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful yet simple to use screenshot software (kloenk's fork)";
    homepage = https://github.com/kloenk/flameshot;
    #maintainers = [ maintainers.scode ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
