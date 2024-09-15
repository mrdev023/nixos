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
        { appId = "net.lutris.Lutris"; origin = "flathub";  }

        # Pro
        { appId = "com.slack.Slack"; origin = "flathub";  }
        { appId = "com.skype.Client"; origin = "flathub";  }
        { appId = "org.mozilla.Thunderbird"; origin = "flathub"; }
        { appId = "ch.protonmail.protonmail-bridge"; origin = "flathub";  }
        { appId = "org.kde.neochat"; origin = "flathub"; }

        # Loisir
        { appId = "com.spotify.Client"; origin = "flathub"; }
        { appId = "io.gitlab.news_flash.NewsFlash"; origin = "flathub"; }
        { appId = "org.videolan.VLC"; origin = "flathub"; }
        { appId = "com.obsproject.Studio"; origin = "flathub"; }
        { appId = "io.github.achetagames.epic_asset_manager"; origin = "flathub"; }
      ];
    };
  };
}