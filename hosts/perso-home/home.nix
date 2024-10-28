{ ... }:

{
  imports = [
    ../../modules/home
  ];

  modules.home = {
    apps = {
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
