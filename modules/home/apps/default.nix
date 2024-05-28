{ config, pkgs, ... }:

{
  imports = [
    ./chromium
    ./flatpak
    ./jetbrainsToolbox
    ./kitty
  ];
}