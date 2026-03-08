{ config, pkgs, ... }:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  programs = {
    obsidian.enable = true;
    k9s.enable = true;
    lazysql.enable = true;
    spicetify.enable = true;
    zen-browser.enable = true;
  };

  modules.home = {
    profiles = [ "shell" ];

    desktop.hyprland.enable = true;
  };

  stylix.image = ../../../assets/backgrounds/4k.jpg;

  # hyprland monitors
  # hyprctl monitors all
  wayland.windowManager.hyprland.settings.monitor = [
    "HDMI-A-1, 2560x1440@75, 0x0, 1"
    "eDP-1, 1920x1200@60, 2560x0, 1"
  ];

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/nixos";

  home.packages = with pkgs; [
    kubectl
  ];
}
