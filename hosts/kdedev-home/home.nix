{
  config,
  lib,
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
    activation.authorizedKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -m 600 ${pkgs.writeText "authorized_keys" ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5smB5CIE9qvUecEExV6A1wpzkN96d9RMMmfMejYZvm
      ''} ~/.ssh/authorized_keys
    '';
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
