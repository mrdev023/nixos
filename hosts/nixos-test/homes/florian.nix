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

  modules.home.profiles = [ "shell" ];

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/Projets/Perso/nixos";
}
