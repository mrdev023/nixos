{
  config,
  nixgl,
  pkgs,
  ...
}:

{
  imports = [
    ../../modules/home
  ];

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  targets.genericLinux.nixGL = {
    packages = nixgl.packages;
    installScripts = [ "mesa" ];
  };

  modules.home = {
    profiles = [
      "shell"
      "hm_only"
    ];
    apps.kitty.package = config.lib.nixGL.wrap pkgs.kitty;
  };

  programs.nh.flake = "${config.home.homeDirectory}/Documents/Perso/nixos";
}
