{
  lib,
  pkgs,
  ...
}:

with lib;
let
  wl-paste = getExe' pkgs.wl-clipboard "wl-paste";
  wl-copy = getExe' pkgs.wl-clipboard "wl-copy";
  cliphist = getExe pkgs.cliphist;
  notify-send = getExe pkgs.libnotify;

  clip_watch = pkgs.writeShellScriptBin "run_cliphist" ''
    ${wl-paste} --watch ${cliphist} store
  '';

  clip_wipe = pkgs.writeShellScriptBin "run_cliphist" ''
    ${cliphist} wipe && ${notify-send} -u low "Presse papier vidé"
  '';

  clip_wofi = pkgs.writeShellScriptBin "run_wofi" ''
    value=$(${cliphist} list | wofi -S dmenu | ${cliphist} decode)
    if [[ -n "$value" ]]; then
      echo "$value" | ${wl-copy}
      ${notify-send} -u low "Élément copié dans le presse papier"
    fi
  '';
in
{
  watch = getExe clip_watch;
  select = getExe clip_wofi;
  wipe = getExe clip_wipe;
}
