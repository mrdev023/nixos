{ config, ... }:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  programs = {
    vesktop.enable = true;
    spicetify.enable = true;
    zen-browser.enable = true;
    obsidian.enable = true;
  };

  services.flatpak.enable = true;

  modules.home.profiles = [ "shell" ];

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/nixos";
}
