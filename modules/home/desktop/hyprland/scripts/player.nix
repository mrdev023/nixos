{ pkgs, lib, ... }:

with lib;
let
  playerctl = getExe pkgs.playerctl;
in
{
  play = "${playerctl} play-pause";
  pause = "${playerctl} play-pause";
  previous = "${playerctl} previous";
  next = "${playerctl} next";
}
