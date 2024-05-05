{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font";
      package = pkgs.fira-code-nerdfont;
    };

    settings = {
      shell = "zsh";
      disable_ligatures = "never";
      sync_to_monitor = "yes"; # Avoid to update a lot
      confirm_os_window_close = 0; # Disable close confirmation

      background_opacity = "0.7";
      background_blur = "1";
    };
  };
}