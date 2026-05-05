{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.configs.kdedev;
in
{
  options.modules.home.configs.kdedev = {
    enable = mkEnableOption "KDE developer configuration for Home Manager";
  };

  config = mkIf cfg.enable {
    home.file."envs/kde.sh".source = ./files/envs/kde.sh;
    home.file."envs/kde_plasma.sh".source = ./files/envs/kde_plasma.sh;
  };
}
