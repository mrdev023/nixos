{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.apps.chromium;
in
{
  options.modules.home.apps.chromium = {
    enable = mkEnableOption ''
      Enable chromium with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;

      package = pkgs.chromium.override {
        enableWideVine = true; # Enable DRM
      };

      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # Ublock Origin
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "fnaicdffflnofjppbagibeoednhnbjhg"; } # Floccus Bookmark manager
        { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I don't care about cookies
        { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # Plasma Integration
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark reader
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
      ];
    };
  };
}