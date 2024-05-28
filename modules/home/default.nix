{ config, pkgs, ... }:

{
  imports = [
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

