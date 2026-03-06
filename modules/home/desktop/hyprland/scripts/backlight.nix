{ pkgs, lib, ... }:

with lib;
let
  xbacklight = getExe pkgs.xbacklight;
in
{
  inc = "${xbacklight} -inc 5";
  dec = "${xbacklight} -dec 5";
}
