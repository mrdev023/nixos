{ config, pkgs, lib, ... }:
with lib;
{
  options.homePrograms.kitty = {
    enable = mkEnableOption ''
      Enable kitty with my custom configurations
    '';

    enableBlur = mkEnableOption ''
      Enable blur (Usefull to disable with hyprland)
    '';
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
              shell = "zsh";
              disable_ligatures = "never";
              sync_to_monitor = "yes"; # Avoid to update a lot
              confirm_os_window_close = 0; # Disable close confirmation

              background_opacity = "0.7";
            }

            (lib.mkIf cfg.enableBlur { background_blur = "1"; })
          ];
        };
      };
}