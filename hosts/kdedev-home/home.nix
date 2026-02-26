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

  modules.home = {
    profiles = [
      "shell"
      "hm_only"
    ];
    apps.kitty.package = config.lib.nixGL.wrap pkgs.kitty;
  };

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/nixos";
}
