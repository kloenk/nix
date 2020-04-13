{ config, lib, pkgs, ... }:

{
  boot.kernelPatches = [
    {
      name = "xtsproxy";
      patch = ./patches/0024-Add-xtsproxy-Crypto-API-module.patch;
    }
    {
      name = "dm-inline";
      patch =
        ./patches/0023-Add-DM_CRYPT_FORCE_INLINE-flag-to-dm-crypt-target.patch;
    }
  ];
}
