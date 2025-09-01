{ config, nixgl, pkgs, ... }:

{
  imports = [
    ../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian/distrobox/kdedev";
  };

  modules.home = {
    profiles = [ "shell" "hm_only" ];
    apps.kitty.package = config.lib.nixGL.wrap pkgs.kitty;
  };
}
