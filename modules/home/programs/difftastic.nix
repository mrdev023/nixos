{ ... }:

{
  config.programs.difftastic = {
    git = {
      enable = true;
      diffToolMode = true;
    };
    jujutsu.enable = true;
  };
}
