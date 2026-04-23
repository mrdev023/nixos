{
  config,
  lib,
  options,
  pkgs,
  ...
}:

with lib;
{
  config = mkMerge [
    (optionalAttrs (options ? stylix) {
      stylix.targets.zen-browser.profileNames = [ "default" ];
    })
    {
      home.file.".zen".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/zen";
      programs.zen-browser = {
        languagePacks = [ "fr" ];

        profiles = {
          default = {
            isDefault = true;
            name = "Default";
            search.default = "qwant";

            settings = {
              "intl.accept_languages" = "fr-FR, fr, en-US, en";
              "intl.locale.requested" = "fr-FR";
              "dom.webgpu.enabled" = true;
              "signon.rememberSignons" = false;
            };

            extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              bitwarden
              floccus
              istilldontcareaboutcookies
              darkreader
              sponsorblock
              tridactyl
            ];
          };
        };
      };
    }
  ];
}
