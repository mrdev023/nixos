{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.system.desktop.plasma;
in {
  options.modules.system.desktop.plasma = {
    enable = mkEnableOption ''
      Enable plasma with my custom configurations
    '';

    enableWallpaperEngine = mkEnableOption ''
      Enable wallpaper engine plugin for plasma
    '';

    enableSddm = mkOption {
      type = types.bool;
      description = "Enable sddm with custom plasma";
      default = true;
    };
  };
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = cfg.enableSddm;
    services.desktopManager.plasma6.enable = true;

    programs = {
      kde-pim = {
        enable = true;
        merkuro = true;
      };
      kdeconnect.enable = true;
    };

    environment.systemPackages = with pkgs;
    with kdePackages;
      [
        krfb # Use by kdeconnect for virtualmonitorplugin "krfb-virtualmonitor"
        discover
        kgpg
        yakuake
      ]
      ++ lib.optionals cfg.enableWallpaperEngine [wallpaper-engine-plugin];
  };
}
