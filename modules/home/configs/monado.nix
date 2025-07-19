{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.configs.monado;
in
{
  options.modules.home.configs.monado = {
    enable = mkEnableOption ''
      Enable monado
    '';
  };
  config = mkIf cfg.enable {
    home.file.".local/share/monado/hand-tracking-models".source =
      pkgs.fetchgit
      {
        url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models";
        sha256 = "x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
        fetchLFS = true;
      };
  };
}