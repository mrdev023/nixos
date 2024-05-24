{ config, pkgs, ... }:

{
  imports = [
    ./programs/agenix.nix
    ./programs/shell.nix
    ./programs/atuin.nix
    ./programs/git.nix
#    ./programs/emacs.nix
    ./programs/jetbrains-toolbox.nix
    ./programs/vscode.nix
    ./programs/direnv.nix
    ./programs/chromium.nix
    ./programs/flatpak.nix

    ./homePrograms
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  homePrograms.kitty.enable = true;
}
