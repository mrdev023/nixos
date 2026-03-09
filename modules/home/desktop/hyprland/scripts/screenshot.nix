{
  pkgs,
  lib,
  ...
}:

with lib;
let
  grim = getExe pkgs.grim;
  slurp = getExe pkgs.slurp;
  xdg-user-dir = getExe' pkgs.xdg-user-dirs "xdg-user-dir";
  notify-send = getExe pkgs.libnotify;
  date = getExe' pkgs.coreutils "date";

  fullscreen = pkgs.writeShellScriptBin "fullscreen_screenshot" ''
    file="$(${xdg-user-dir} PICTURES)/$(${date} +%Y%m%d_%H%M%S).png"
    ${grim} "$file" && ${notify-send} -u low "Nouvelle capture d'écran: $file"
  '';

  region = pkgs.writeShellScriptBin "region_screenshot" ''
    file="$(${xdg-user-dir} PICTURES)/$(${date} +%Y%m%d_%H%M%S).png"
    ${grim} -g "$(${slurp})" "$file" && ${notify-send} -u low "Nouvelle capture d'écran: $file"
  '';
in
{
  fullscreen = getExe fullscreen;
  region = getExe region;
}
