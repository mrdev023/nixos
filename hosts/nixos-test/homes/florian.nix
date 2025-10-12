{...}:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  modules.home = {
    desktop.hyprland.enable = true;

    profiles = [ "shell" ];
  };
}
