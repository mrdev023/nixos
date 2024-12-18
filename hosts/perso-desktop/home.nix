{ ... }:

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

    shell = {
      zsh.enable = true;
      atuin.enable = true;
      direnv.enable = true;
      git.enable = true;
    };
  };
}

