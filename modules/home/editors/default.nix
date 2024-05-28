{ config, pkgs, ... }:

{
  imports = [
    ./emacs
    ./vscode
  ];
}