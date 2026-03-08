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

  programs.kitty.package = config.lib.nixGL.wrap pkgs.kitty;

  modules.home = {
    profiles = [
      "shell"
      "hm_only"
    ];
  };

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/nixos";
}
