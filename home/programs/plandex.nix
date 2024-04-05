{ config, pkgs, ... }:
let
  plandex_cli = pkgs.callPackage ../../pkgs/plandex_cli.nix { };
in
{
  home.packages = [plandex_cli];
}
