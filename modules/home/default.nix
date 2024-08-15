{ config, pkgs, ... }:

{
  imports = [
    ../common.nix
    ./apps
    ./desktop
    ./shell
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}

