{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.home.apps.spotify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  options.modules.home.apps.spotify = {
    enable = mkEnableOption ''
      Enable spotify
    '';
  };
  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        keyboardShortcut
      ];
    };
  };
}
