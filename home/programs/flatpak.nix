{ config, pkgs, nix-flatpak, ... }:

{
  imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    uninstallUnmanagedPackages = true;

    packages = [
      { appId = "com.discordapp.Discord"; origin = "flathub";  }
      { appId = "com.valvesoftware.Steam"; origin = "flathub";  }
    ];
  };
}
