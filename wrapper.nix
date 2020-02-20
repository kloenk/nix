{ ... }:

{
inherit (import ./default.nix { secrets = toString ./../../.password-store; }) deploy;
}
