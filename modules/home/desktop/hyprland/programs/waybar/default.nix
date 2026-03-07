{
  lib,
  pkgs,
  ...
}:

with lib;
let
  variables = import ../../variables.nix;
in
{
  stylix.targets.waybar.addCss = false;

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
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        ipc = true;
        fixed-center = true;
        height = variables.topBar.height;
        # Use same values as windows for consistence
        margin-top = variables.window.gap;
        margin-left = variables.window.gap;
        margin-right = variables.window.gap;
        margin-bottom = 0; # Use gaps_out configured in hyprland

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "mpris"
          "clock"
        ];

        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "bluetooth"
          "privacy"
          "tray"
        ];

        mpris = {
          format = "{player_icon} {title} - {artist}";
          format-paused = "{status_icon} <i>{title} - {artist}</i>";
          player-icons = {
            default = "";
          };
          status-icons = {
            paused = "⏸";
            playing = "";
          };
          max-length = 30;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };

        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%a, %d %b, %H:%M}";
          timezone = "Europe/Paris";
          locale = "fr_FR.UTF-8";
        };

        tray = {
          spacing = variables.topBar.gap;
        };

        pulseaudio = {
          on-click = getExe pkgs.pavucontrol;
          scroll-step = 5;
          format = "{icon}";
          format-muted = "";
          format-icons.default = [
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          on-click = "${getExe pkgs.kitty} --title nmtui ${getExe' pkgs.networkmanager "nmtui"}";
          format = "{ifname}";
          format-wifi = "";
          format-ethernet = "󰈀";
          format-disconnected = "󰌙";
          tooltip-format = "{ifname} via {gwaddr} 󰊗";
          tooltip-format-wifi = "<big>{essid}</big>\n<tt>{signalStrength}%</tt>";
          tooltip-format-ethernet = "<big>{ifname}</big>\n<tt>{ipaddr}/{cidr}</tt>";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
        };

        bluetooth = {
          on-click = "${getExe pkgs.overskride}";
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };

        privacy = {
          icon-spacing = variables.topBar.gap;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
            }
            {
              type = "audio-in";
              tooltip = true;
            }
          ];
        };
      };
    };

    style =
      let
        border.radius = toString variables.window.border.radius;
        workspace.radius = toString (variables.window.border.radius / 2);
        padding.x = toString (variables.window.gap * 2);
        modules.gap = toString (variables.topBar.gap / 2);
      in
      mkAfter ''
        /* Custom section */
        * {
          margin: 0px;
          padding: 0px;
        }

        window#waybar {
          transition-property: background-color;
          transition-duration: 0.5s;
          background: transparent;
          color: @base05;
          font-size: ${toString variables.icon.size}px;
        }

        tooltip {
          border-radius: ${border.radius}px;
          border-color: @base0D;
        }

        tooltip label {
          color: @base05;
          margin-right: 5px;
          margin-left: 5px;
        }

        .modules-left,
        .modules-center,
        .modules-right {
          background: @base00;
          padding-right: ${padding.x}px;
          padding-left: ${padding.x}px;
          border-radius: ${border.radius}px;
        }

        /* Gap for all modules */
        #clock,
        #mpris,
        #pulseaudio,
        #network,
        #bluetooth,
        #privacy,
        #idle_inhibitor,
        #tray {
            padding: 0 ${modules.gap}px;
        }

        /* Workspaces */
        #workspaces button {
            margin: ${modules.gap}px 0;
            padding: 0 ${modules.gap}px;
            color: @base03;
            border: none;
            transition: all 0.2s ease;
            border-radius: ${workspace.radius}px;
        }

        #workspaces button.active,
        #workspaces button.focused {
            color: @base04;
            background: alpha(@base01, 0.6);
        }

        #workspaces button:hover {
            background: alpha(@base02, 0.4);
            color: @base05;
        }

        #workspaces button.urgent {
            background: @base08;
            color: @base00;
        }
      '';
  };
}
