{ config, pkgs, lib, ... }:
with lib;
{
  options.homePrograms.kitty = {
    enable = mkOption {
      default = config.homePrograms.hyprland.enable; # Enable by default with hyprland to ensure kitty is installed with hyprland
      example = true;
      description = ''
        Enable kitty with my custom configurations
      '';
      type = types.bool;
    };

    enableBlur = mkOption {
      default = !config.homePrograms.hyprland.enable; # Disable by default if hyprland is enabled (Hyprland enable own blur)
      example = true;
      description = ''
        Enable blur (Usefull to disable with hyprland)
      '';
      type = types.bool;
    };
  };
  config =
    let
      cfg = config.homePrograms.kitty;
    in
      mkIf cfg.enable {
        programs.kitty = {
          enable = true;

          font = {
            name = "FiraCode Nerd Font";
            package = pkgs.fira-code-nerdfont;
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