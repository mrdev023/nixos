{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
#    ./programs/emacs.nix
    ./programs/jetbrains-toolbox.nix
    ./programs/vscode.nix
    ./programs/mise.nix
    ./programs/chromium.nix
    ./programs/flatpak.nix
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
