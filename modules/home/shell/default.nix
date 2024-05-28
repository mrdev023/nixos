{ config, pkgs, ... }:

{
  imports = [
    ./atuin
    ./direnv
    ./git
    ./zsh
  ];
}