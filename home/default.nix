{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/emacs.nix
    ./programs/vscode.nix
    ./programs/mise.nix
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
