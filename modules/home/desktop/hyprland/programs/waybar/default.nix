{
  lib,
  ...
}:

with lib;
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

        modules-left = [
          "hyprland/workspaces"
          "mpris"
        ];

        modules-center = [
          "idle_inhibitor"
          "clock"
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "bluetooth"
          "tray"
        ];

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
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%a, %d %b, %H:%M}";
        };
      };
    };

    style = mkAfter ''
      * {
        margin: 0px;
        padding: 0px;
      }

      window#waybar {
        transition-property: background-color;
        transition-duration: 0.5s;
        background: transparent;
        border-radius: 10px;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      tooltip {
        border-radius: 8px;
      }

      tooltip label {
        margin-right: 5px;
        margin-left: 5px;
      }

      /* This section can be use if you want to separate waybar modules */
      .modules-left {
        background: @base00;
        padding-right: 15px;
        padding-left: 2px;
        border-radius: 10px;
      }
      .modules-center {
        background: @base00;
        padding-right: 5px;
        padding-left: 5px;
        border-radius: 10px;
      }
      .modules-right {
        background: @base00;
        padding-right: 15px;
        padding-left: 15px;
        border-radius: 10px;
      }
    '';
  };
}
