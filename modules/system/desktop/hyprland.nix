{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.system.desktop.hyprland;
  hasPlasma = config.services.desktopManager.plasma6.enable;
in
{
  options.modules.system.desktop.hyprland = {
    enable = mkEnableOption ''
      Enable hyprland with my custom configurations
    '';
  };
  config = mkIf cfg.enable (mkMerge [
    {
      services.displayManager.sddm.enable = mkDefault true;
      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;
      security.pam.services.login.enableGnomeKeyring = true;
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
    }
    (mkIf (!hasPlasma) {
      services.displayManager.sddm.wayland = {
        enable = true;
        # weston 15 crashe sur RDNA4 (gfx1201) à cause de modifiers DRM dupliqués
        compositor = "kwin";
      };
      environment.systemPackages = with pkgs; [
        kdePackages.breeze
        adwaita-icon-theme
      ];
      services.displayManager.sddm.settings.Theme.CursorTheme = "breeze_cursors";
      environment.variables = {
        XCURSOR_THEME = "breeze_cursors";
        XCURSOR_SIZE = "24";
      };
    })
  ]);
}
