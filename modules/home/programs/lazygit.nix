{ ... }:

{
  config.programs.lazygit.settings.git = {
    pagers = [
      { externalDiffCommand = "difft --color=always"; }
    ];
    overrideGpg = true;
  };
}
