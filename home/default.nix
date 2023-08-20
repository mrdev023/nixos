{ config, pkgs, ... }:

{
  imports = [
    ./hyprland
    ./programs
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
}
