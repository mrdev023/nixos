{
  pkgs,
  lib,
  ...
}:

with lib;
{
  stylix = {
    # TODO: Enable by DE
    # autoEnable = mkDefault false;
    polarity = mkDefault "dark";
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        desktop = 14;
        popups = 10;
      };
    };
  };
}
