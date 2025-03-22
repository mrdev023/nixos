{ config, lib, ... }:

with lib;
let
  cfg = config.modules.home.apps.flatpak;
in
{
  options.modules.home.apps.flatpak = {
    enable = mkEnableOption ''
      Enable flatpak with my custom configurations
    '';
  };

  config = mkIf cfg.enable {
    services.flatpak = {
      enable = true;

      update.onActivation = true;

      packages = [
        # Gaming
        { appId = "com.discordapp.Discord"; origin = "flathub";  }

        # Pro
        { appId = "ch.protonmail.protonmail-bridge"; origin = "flathub";  }
        { appId = "org.kde.neochat"; origin = "flathub"; }

        # Loisir
        { appId = "io.github.zen_browser.zen"; origin = "flathub"; }
        { appId = "com.spotify.Client"; origin = "flathub"; }
        { appId = "org.videolan.VLC"; origin = "flathub"; }
      ];
    };
  };
}