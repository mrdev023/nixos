{ config, pkgs, ... }:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  modules.home = {
    profiles = [ "shell" ];
    desktop.hyprland.enable = true;
  };

  stylix.image = pkgs.fetchurl {
    url = "https://getwallpapers.com/wallpaper/full/1/4/3/523784.jpg";
    hash = "sha256-S/6kgloXiIYI0NblT6YVXfqELApbdHGsuYe6S4JoQwQ=";
  };

  # hyprland monitors
  # hyprctl monitors all
  wayland.windowManager.hyprland.settings.monitor = [
    "HDMI-A-1, 2560x1440@75, 0x0, 1"
    "eDP-1, 1920x1200@60, 2560x0, 1"
  ];

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/nixos";

  home.packages = with pkgs; [
    kubectl
    lazysql
    k9s
  ];
}
