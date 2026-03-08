{ ... }:

{
  config.programs.lazygit.settings.git = {
    paging.externalDiffCommand = "difft --color=always";
    overrideGpg = true;
  };
}
