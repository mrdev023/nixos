{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;

    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # Ublock Origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "fnaicdffflnofjppbagibeoednhnbjhg"; } # Floccus Bookmark manager
      { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I don't care about cookies
    ];
  };
}