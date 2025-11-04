{ pkgs, ...}:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  home.packages = with pkgs; [
    libnotify
  ];

  modules.home = {
    desktop.hyprland.enable = true;

    profiles = [ "shell" ];
  };
}
