{ config, pkgs, ... }:

{
  programs.mise = {
    enable = true;

    settings = {
      experimental = true;
    };
  };
}