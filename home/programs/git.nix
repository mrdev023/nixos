{
  pkgs,
  ...
}: {
  home.packages = [];

  programs.git = {
    enable = true;
    userName = "Florian RICHER";
    userEmail = "florian.richer@protonmail.com";
  };
}