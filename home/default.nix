{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/emacs.nix
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
