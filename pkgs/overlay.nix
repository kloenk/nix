final: prev: let 
  inherit (final) callPackage;
in {
    collectd-wireguard = callPackage ./collectd-wireguard { };
    jblock = callPackage ./jblock { };
    quassel = prev.quassel.overrideAttrs (oldAttrs: rec {
      name = "quassel-${version}";
      version = "0.14-pre";
      buildInputs = oldAttrs.buildInputs ++ [ final.boost ];
      src = final.fetchFromGitHub {
        owner = "quassel";
        repo = "quassel";
        rev = "b134e777b822b929a78455fd92146bf7443e9aa1";
        sha256 = "0yzbyjycsff1cw0py9nagd2j1il3sw8ihal4bpv80hlvwi9f07rr";
      };
      cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DPSQL_INCDIR=${final.postgresql}/include" ];
    });
}


/*let
  #lib = pkgs.lib;
  callPackage = lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
    collectd-wireguard = callPackage ./collectd-wireguard { };
    jblock = callPackage ./jblock { };
    quassel = pkgs.quassel.overrideAttrs (oldAttrs: rec {
      name = "quassel-${version}";
      version = "0.14-pre";
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.boost ];
      src = pkgs.fetchFromGitHub {
        owner = "quassel";
        repo = "quassel";
        rev = "b134e777b822b929a78455fd92146bf7443e9aa1";
        sha256 = "0yzbyjycsff1cw0py9nagd2j1il3sw8ihal4bpv80hlvwi9f07rr";
      };
      cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DPSQL_INCDIR=${pkgs.postgresql}/include" ];
    });
    #engelsystem = callPackage ./engelsystem { };
    #engelsystem = callPackage ./engelsystem { };
    #rifo = callPackage ./rifo { };
    #rwm = callPackage ./rwm { };
    #dwm = callPackage ./dwm { rwm = newpkgs.rwm; };
    #slstatus = callPackage ./slstatus { };
    #ftb = callPackage ./ftb { libXxf86vm = pkgs.xorg.libXxf86vm; };
    #flameshot = pkgs.libsForQt5.callPackage ./flameshot { };
    #llgCompanion = callPackage ./llgCompanion { };
    #shelfie = callPackage ./shelfie { };
    #pytradfri = callPackage ./pytradfri { buildPythonPackage = pkgs.python37Packages.buildPythonPackage; fetchPypi = pkgs.python37Packages.fetchPypi; cython = pkgs.python37Packages.cython; };
    #aiocoap = callPackage ./aiocoap { buildPythonPackage = pkgs.python37Packages.buildPythonPackage; fetchPypi = pkgs.python37Packages.fetchPypi; cython = pkgs.python37Packages.cython; };
    #inherit (callPackage ./minecraft-server { })
    #  minecraft-server_1_14_2;
  };

in newpkgs*/
