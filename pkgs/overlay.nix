final: prev:
let inherit (final) callPackage;
in {
  collectd-wireguard = callPackage ./collectd-wireguard { };
  jblock = callPackage ./jblock { };
  deploy_secrets = callPackage ./deploy_secrets { };
  wallpapers = callPackage ./wallpapers { };
  fabric-server = callPackage ./fabric-server { };

  # broken packages
  waybar = prev.waybar.overrideAttrs (oldAttrs: rec {
    version = "0.9.1";
    src = final.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = version;
      sha256 = "0drlv8im5phz39jxp3gxkc40b6f85bb3piff2v3hmnfzh7ib915s";
    };
  });

  minecraft-20w20a = prev.minecraft-server.overrideAttrs (oldAttrs: rec {
    version = "1.16-pre20w20a";
    src = final.fetchurl {
      url =
        "https://launcher.mojang.com/v1/objects/0393774fb1f9db8288a56dbbcf45022b71f7939f/server.jar";
      sha256 =
        "933a424ad1e82d33b0d782b54158e877969dd0893329f190495ca3ba287e8358";
    };
  });

  redshift = prev.redshift.overrideAttrs (oldAttrs: rec {
    src = final.fetchFromGitHub {
      owner = "minus7";
      repo = "redshift";
      rev = "eecbfedac48f827e96ad5e151de8f41f6cd3af66";
      sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
    };
  });
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
    cmakeFlags = oldAttrs.cmakeFlags
      ++ [ "-DPSQL_INCDIR=${final.postgresql}/include" ];
  });

  hydra-patched = prev.hydra-unstable.overrideAttrs (oldAttrs: rec {
    src = final.fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "c4104fe1fa7f1326b959c0c38ed8a3fbfd65e339";
      sha256 = "1bw5mq5a6ym4prxzd705xk8wwfb5z9a4m6014i2w5yrqxgclnr6v";
    };
  });
}

/* let
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

   in newpkgs
*/
