{ config, pkgs, nix-flatpak, ... }:

{
  imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

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
    ];
  };
}
