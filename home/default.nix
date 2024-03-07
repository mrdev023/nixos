{ config, pkgs, ... }:

{
  imports = [
    ./programs/shell.nix
    ./programs/git.nix
#    ./programs/emacs.nix
    ./programs/jetbrains-toolbox.nix
    ./programs/vscode.nix
    ./programs/direnv.nix
    ./programs/chromium.nix
    ./programs/flatpak.nix
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
