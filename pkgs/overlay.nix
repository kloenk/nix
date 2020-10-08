final: prev:
let inherit (final) callPackage;
in {
  collectd-wireguard = callPackage ./collectd-wireguard { };
  jblock = callPackage ./jblock { };
  deploy_secrets = callPackage ./deploy_secrets { };
  wallpapers = callPackage ./wallpapers { };
  fabric-server = callPackage ./fabric-server { };
  pam_nfc = callPackage ./pam_nfc { };

  libnfc0 = callPackage ./libnfc { };

  redshift = prev.redshift.overrideAttrs (oldAttrs: rec {
    src = final.fetchFromGitHub {
      owner = "minus7";
      repo = "redshift";
      rev = "eecbfedac48f827e96ad5e151de8f41f6cd3af66";
      sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
    };
  });

  spidermonkey_38 = null;

  inherit (final.callPackage ./firefox { })
    firefoxPolicies firefox-policies-wrapped;

  nix-serve = prev.nix-serve.overrideAttrs (oldAttrs: rec {
    meta = oldAttrs.meta // { platforms = final.lib.platforms.linux; };
  });

  rustc_nightly = prev.rustc.overrideAttrs (oldAttrs: {
    configureFlags = map (flag:
      if flag == "--release-channel=stable" then
        "--release-channel=nightly"
      else
        flag) oldAttrs.configureFlags;
  });

  linux_rust = let
    linux_rust_pkg = { fetchFromGitHub, buildLinux, clang_11, llvm_11
      , rustc_nightly, cargo, ... }@args:
      buildLinux (args // rec {
        version = "5.9.0-rc2";
        modDirVersion = version;

        src = fetchFromGitHub {
          owner = "kloenk";
          repo = "linux";
          rev = "cc175e9a774a4b758029c1e6ca69db00b5e19fdc";
          sha256 = "sha256-EYCVtEd2/t98d0UbmINlMoJuioRqD3ZxrSVMADm22SE=";
        };
        kernelPatches = [ ];

        extraNativePackages = [ clang_11 llvm_11 rustc_nightly cargo ];

        extraMeta.branch = "5.9";

      } // (args.argsOverride or { }));
  in callPackage linux_rust_pkg { };
}

