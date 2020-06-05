{ lib, config, ... }:

let
  cfg = config.programs.firefox;

  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options = {
    programs.firefox = {
      enable = mkEnableOption "firefox policie management";

      policies = mkOption {
        type = types.attrs;
        default = {};
        description = "firefox policy rules";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."firefox/policies.json".text = builtins.toJSON { policies = cfg.policies; };
  };
}
