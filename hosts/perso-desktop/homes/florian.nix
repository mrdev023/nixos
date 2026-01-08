{ pkgs, ... }:

{
  imports = [
    ../../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  modules.home = {
    apps.flatpak.enable = true;
    apps.discord.enable = true;
    apps.scrcpy.enable = true;

    configs.distrobox.enable = true;

    profiles = [ "shell" ];
  };
}
