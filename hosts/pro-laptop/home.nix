{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home
  ];

  modules.home = {
    apps = {
      chromium.enable = true;
      firefox.enable = true;
      flatpak.enable = true;
      jetbrainsToolbox.enable = true;
      kitty.enable = true;
    };

    editors = {
      emacs.enable = true;
      vscode.enable = true;
    };

    shell = {
      zsh.enable = true;
      atuin.enable = true;
      direnv.enable = true;
      git.enable = true;
    };
  };
}

