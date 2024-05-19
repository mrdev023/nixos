{ config, pkgs, ... }:

{
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
}
