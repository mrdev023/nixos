{ config, ... }:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  modules.home = {
    apps.flatpak.enable = true;
    apps.discord.enable = true;
    apps.zen-browser.enable = true;
    apps.spotify.enable = true;
    apps.obsidian.enable = true;

    desktop.hyprland.enable = true;

    configs.distrobox.enable = true;

    profiles = [ "shell" ];
  };

  stylix.image = ../../../assets/backgrounds/4k.jpg;

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/nixos";
}
