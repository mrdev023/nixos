{ config, pkgs, ... }:

{
  imports = [
#    ./hyprland
    ./programs
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
