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
    homeDirectory = "/home/florian/distrobox/kdedev";
  };

  modules.home = {
    profiles = [
      "shell"
      "hm_only"
    ];
    configs.distrobox.enable = true;
  };

  programs.zed-editor.enable = true;
  programs.zed-editor.package = config.lib.nixGL.wrap pkgs.zed-editor;
}
