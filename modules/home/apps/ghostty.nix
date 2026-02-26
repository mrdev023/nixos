{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.apps.ghostty;
  cfgFont = config.modules.home.shell.font;
in
{
  options.modules.home.apps.ghostty = {
    enable = mkEnableOption ''
      Enable ghostty with my custom configurations
    '';

    enableBlur = mkOption {
      default = !config.modules.home.desktop.hyprland.enable; # Disable by default if hyprland is enabled (Hyprland enable own blur)
      example = true;
      description = ''
        Enable blur (Usefull to disable with hyprland)
      '';
      type = types.bool;
    };

    package = lib.mkPackageOption pkgs "ghostty" { };
  };
  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      inherit (cfg) package;

      settings = lib.mkMerge [
        {
          background-opacity = "0.7";
          font-family = cfgFont.name;
          window-decoration = if pkgs.stdenv.hostPlatform.isDarwin then false else true;

          # Enable ligatures
          font-feature = "+liga,+dlig,+calt";
        }

        (lib.mkIf cfg.enableBlur { background-blur = "1"; })
        (lib.mkIf config.programs.zsh.enable { command = "zsh"; })
      ];
    };
  };
}
