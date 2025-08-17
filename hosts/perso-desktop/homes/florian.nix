{...}:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  modules.home = {
    apps = {
      flatpak.enable = true;
      kitty.enable = true;
    };

    configs = {
      distrobox.enable = true;
    };

    editors = {
      neovim.enable = true;
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
