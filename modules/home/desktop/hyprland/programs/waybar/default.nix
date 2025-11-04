{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = false;
      target = "graphical-session.target";
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mode = "dock";
        height = 32;
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        ipc = true;
        fixed-center = true;
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;
        margin-bottom = 0;

        modules-left = [ "mpris" ];

        modules-center = [];

        modules-right = [ "tray" "clock" ];

        mpris = {
          format = "{player_icon} {title} - {artist}";
          format-paused = "{status_icon} <i>{title} - {artist}</i>";
          player-icons = {
            default = "▶";
          };
          status-icons = {
            paused = "⏸";
            playing = "";
          };
          max-length = 30;
        };

        tray = {
          icon-size = 12;
          spacing = 5;
        };

        clock = {
          timezone = "Europe/Paris";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%a, %d %b, %I:%M %p}";
        };
      };
    };

    style = ''

    '';
  };
}
