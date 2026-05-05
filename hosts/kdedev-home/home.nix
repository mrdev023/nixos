{
  config,
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
    configs.kdedev.enable = true;
  };

  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/nixos";

  programs.kitty.package = config.lib.nixGL.wrap pkgs.kitty;
  programs.zed-editor.enable = true;
  programs.zed-editor.package = config.lib.nixGL.wrap pkgs.zed-editor;
}
