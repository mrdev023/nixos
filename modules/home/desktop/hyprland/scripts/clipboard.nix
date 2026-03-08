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
  wofi = getExe pkgs.wofi;

  clip_watch = pkgs.writeShellScriptBin "run_cliphist" ''
    ${wl-paste} --watch ${cliphist} store
  '';

  clip_wofi = pkgs.writeShellScriptBin "run_wofi" ''
    ${cliphist} list | ${wofi} -S dmenu | ${cliphist} decode | ${wl-copy}
  '';
in
{
  watch = getExe clip_watch;
  select = getExe clip_wofi;
}
