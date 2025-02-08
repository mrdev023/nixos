{ ... }:

{
  imports = [
    ../../modules/home
  ];

  modules.home = {
    editors.vscode.enable = true;

    apps = {
      flatpak.enable = true;
      jetbrainsToolbox.enable = true;
      kitty.enable = true;
      minecraft.enable = true;
    };

    shell = {
      zsh.enable = true;
      atuin.enable = true;
      direnv.enable = true;
      git.enable = true;
    };
  };
}

