{ config, lib, ... }:

with lib;
let
  cfg = config.modules.system.hardware.keymaps;
in
{
  options.modules.system.hardware.keymaps = {
    layout = mkOption {
      default = "fr";
      example = "fr";
      description = ''
        Set key layout (fr, us)
      '';
      type = types.str;
    };
  };
  config = mkMerge [
    (mkIf (cfg.layout == "fr") (import ./fr.nix {}))
    (mkIf (cfg.layout == "us") (import ./us.nix {}))
  ];
}

