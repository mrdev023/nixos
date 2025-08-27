{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.apps.kitty;
  cfgFont = config.modules.home.shell.font;
in
{
  options.modules.home.apps.kitty = {
    enable = mkEnableOption ''
      Enable kitty with my custom configurations
    '';

    enableBlur = mkOption {
      default = !config.modules.home.desktop.hyprland.enable; # Disable by default if hyprland is enabled (Hyprland enable own blur)
      example = true;
      description = ''
        Enable blur (Usefull to disable with hyprland)
      '';
      type = types.bool;
    };

    package = mkPackageOption pkgs "kitty" { };
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      inherit (cfg) package;

      font.name = cfgFont.name;

      settings = mkMerge [
        {
          disable_ligatures = "never";
          sync_to_monitor = "yes"; # Avoid to update a lot
          confirm_os_window_close = 0; # Disable close confirmation
          # hide_window_decorations = if pkgs.stdenv.hostPlatform.isDarwin then "titlebar-and-corners" else "yes";

          background_opacity = "0.7";
        }

        (mkIf cfg.enableBlur { background_blur = "1"; })
        (mkIf config.programs.zsh.enable { shell = "zsh"; })
      ];
    };
  };
}
