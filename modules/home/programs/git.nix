{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.programs.git;
in
{
  config = {
    home.packages = optionals cfg.enable (with pkgs; [ gitflow ]);

    programs.git = {
      lfs.enable = true;

      signing = {
        signByDefault = true;
        format = "openpgp";
        key = "B19E3F4A2D806AB4793FDF2FC73D37CBED7BFC77";
      };

      settings = {
        user = {
          name = "Florian RICHER";
          email = "florian.richer@protonmail.com";
        };

        pull.rebase = "true";
        url."https://invent.kde.org/".insteadOf = "kde:";
        url."ssh://git@invent.kde.org/".pushInsteadOf = "kde:";
      };
    };
  };
}
