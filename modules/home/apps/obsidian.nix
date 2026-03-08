{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.apps.obsidian;
  cfgStylix = config.stylix;
in
{
  options.modules.home.apps.obsidian = {
    enable = mkEnableOption ''
      Enable obsidian with my custom configurations
    '';
  };
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfgStylix.enable {
      stylix.targets.obsidian.vaultNames = [ "perso_obsidian_vault" ];
    })
    {
      programs.obsidian = {
        enable = true;
      };
    }
  ]);
}
