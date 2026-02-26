{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.shell.font;
in
{
  options.modules.home.shell.font = {
    name = mkOption {
      type = types.str;
      description = "Font name to use";
      default = "FiraCode Nerd Font";
    };

    package = mkPackageOption pkgs [ "nerd-fonts" "fira-code" ] { };
  };
  config = {
    home.packages = [ cfg.package ];
  };
}
