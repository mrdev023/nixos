{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
#    ./programs/emacs.nix
#    ./programs/vscode.nix
    ./programs/mise.nix
    ./programs/chromium.nix
#    ./programs/discord.nix
#    ./programs/skype.nix
#    ./programs/slack.nix
#    ./programs/thunderbird.nix
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
