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
    file.".ssh/authorized_keys" = {
      text = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5smB5CIE9qvUecEExV6A1wpzkN96d9RMMmfMejYZvm
      '';
      mode = "0600";
    };
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
