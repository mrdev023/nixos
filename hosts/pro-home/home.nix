{ ... }:

{
  imports = [
    ../../modules/home
  ];

  modules.home = {
    shell = {
      zsh.enable = true;
      atuin.enable = true;
      direnv.enable = true;
    };
  };
}
