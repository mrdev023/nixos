{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.apps.kitty;
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
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerd-fonts.fira-code;
      };

      settings = lib.mkMerge [
        {
          disable_ligatures = "never";
          sync_to_monitor = "yes"; # Avoid to update a lot
          confirm_os_window_close = 0; # Disable close confirmation

          background_opacity = "0.7";
        }

        (lib.mkIf cfg.enableBlur { background_blur = "1"; })
        (lib.mkIf config.programs.zsh.enable { shell = "zsh"; })
      ];
    };
  };
}