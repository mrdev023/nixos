{ config, pkgs, nix-flatpak, ... }:

{
  imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    update.onActivation = true;

    uninstallUnmanagedPackages = true;

    packages = [
      # Gaming
      { appId = "com.discordapp.Discord"; origin = "flathub";  }
      { appId = "com.valvesoftware.Steam"; origin = "flathub";  }
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

      # Autres
      { appId = "com.github.debauchee.barrier"; origin = "flathub"; }
    ];
  };
}
