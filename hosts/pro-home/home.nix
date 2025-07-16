{ config, nixgl, pkgs, ... }:

{
  imports = [
    ../../modules/home
  ];

  nixGL = {
    packages = nixgl.packages;
    installScripts = ["mesa"];
  };

  modules.home = {
    apps = {
      kitty = {
        enable = true;
        package = config.lib.nixGL.wrap pkgs.kitty;
      };
    };

    shell = {
      atuin.enable = true;
      direnv.enable = true;
      git.enable = true;
      lazygit.enable = true;
      zsh.enable = true;
    };

    editors.neovim.enable = true;
  };
}
