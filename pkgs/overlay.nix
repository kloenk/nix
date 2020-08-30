final: prev:
let inherit (final) callPackage;
in {
  collectd-wireguard = callPackage ./collectd-wireguard { };
  jblock = callPackage ./jblock { };
  deploy_secrets = callPackage ./deploy_secrets { };
  wallpapers = callPackage ./wallpapers { };
  fabric-server = callPackage ./fabric-server { };
  pam_nfc = callPackage ./pam_nfc {
    #libnfc = final.libnfc0;
  };

  libnfc0 = callPackage ./libnfc { };

  # broken packages
  /*waybar = prev.waybar.overrideAttrs (oldAttrs: rec {
    version = "0.9.1";
    src = final.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = version;
      sha256 = "0drlv8im5phz39jxp3gxkc40b6f85bb3piff2v3hmnfzh7ib915s";
    };
  });*/

  minecraft-20w20a = prev.minecraft-server.overrideAttrs (oldAttrs: rec {
    version = "1.16-pre3";
    src = final.fetchurl {
      url =
        "https://launcher.mojang.com/v1/objects/0b5653b65bc494fa55349682cebf50abf0d72ad9/server.jar";
      sha1 = "0b5653b65bc494fa55349682cebf50abf0d72ad9";
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
  waybar = prev.waybar.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [ final.libinput ];
  });
  /* quassel = prev.quassel.overrideAttrs (oldAttrs: rec {
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
  */

  #inherit (final.callPackage ./hydra { }) hydra-unstable;

  inherit (final.callPackage ./firefox { })
    firefoxPolicies firefox-policies-wrapped;

  nix-serve = prev.nix-serve.overrideAttrs (oldAttrs: rec {
    meta = oldAttrs.meta // { platforms = final.lib.platforms.linux; };
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
