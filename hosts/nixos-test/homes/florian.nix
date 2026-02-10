{ config, pkgs, ... }:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  home.packages = with pkgs; [
    libnotify
  ];

  modules.home = {
    desktop.hyprland.enable = true;

    profiles = [ "shell" ];
  };

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/nixos";
}
