{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.apps.firefox;
in
{
  options.modules.home.apps.firefox = {
    enable = mkEnableOption ''
      Enable firefox with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
      ];

      profiles = {
        perso = {
          id = 0;

          name = "Perso";

          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            floccus
            plasma-integration
            istilldontcareaboutcookies
            darkreader
          ];

          settings = {
            # Enable multi-pip
            "media.videocontrols.picture-in-picture.allow-multiple" = true;
          };
        };
      };
    };
  };
}
