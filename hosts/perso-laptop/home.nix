{ ... }:

{
  imports = [
    ../../modules/home
  ];

  modules.home = {
    apps = {
      flatpak.enable = true;
      kitty.enable = true;
    };

    editors = {
      neovim.enable = true;
      vscode.enable = true;
    };

    shell = {
      zsh.enable = true;
      atuin.enable = true;
      direnv.enable = true;
      git.enable = true;
      lazygit.enable = true;
    };
  };
}

