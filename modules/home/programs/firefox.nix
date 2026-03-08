{
  pkgs,
  ...
}:

{
  config.programs.firefox = {
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
}
