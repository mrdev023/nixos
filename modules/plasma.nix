{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "plasma";
  };
  services.desktopManager.plasma6.enable = true;

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; with kdePackages; [
    krfb # Use by kdeconnect for virtualmonitorplugin "krfb-virtualmonitor"
    kdenetwork-filesharing # Use to share with samba from dolphin
    samba4Full # Required for kdenetwork-filesharing
  ];
}
