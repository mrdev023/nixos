{ pkgs, agenix, ... }:

{
  home.packages = [
    agenix.packages."${pkgs.system}".default
  ];
}