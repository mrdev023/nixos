{
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
  };

  home.file."run.sh".source = ./files/run.sh;
  home.file."copy_polkit.sh" = {
    executable = true;
    source = ./files/copy_polkit.sh;
  };

  xdg.configFile."kdedev/env.sh".source = ./files/env.sh;
  xdg.configFile."kdedev/setup.sh".source = ./files/setup.sh;

  programs.zsh.initExtra = ''
    source "$HOME/.config/kdedev/env.sh"
    source "$HOME/.config/kdedev/setup.sh"
  '';
}
