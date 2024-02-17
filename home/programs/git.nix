{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Florian RICHER";
    userEmail = "florian.richer@protonmail.com";
  };
}