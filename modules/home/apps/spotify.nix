{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.apps.spotify;
in
{
  options.modules.home.apps.spotify = {
    enable = mkEnableOption ''
      Enable spotify
    '';
  };
  config = mkIf cfg.enable {
    programs.spicetify.enable = true;
  };
}
