{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.apps.zen-browser;
  cfgStylix = config.stylix;
in
{
  options.modules.home.apps.zen-browser = {
    enable = mkEnableOption ''
      Enable firefox with my custom configurations
    '';
  };
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfgStylix.enable {
      stylix.targets.zen-browser.profileNames = [ "default" ];
    })
    {
      home.file.".zen".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/zen";
      programs.zen-browser = {
        enable = true;

        profiles = {
          default = {
            isDefault = true;
            name = "Default";
            search.default = "qwant";

            settings = {
              "intl.accept_languages" = "fr-FR, fr, en-US, en";
              "intl.locale.requested" = "fr-FR";
            };

            extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              bitwarden
              floccus
              istilldontcareaboutcookies
              darkreader
              sponsorblock
            ];
          };
        };
      };
    }
  ]);
}
