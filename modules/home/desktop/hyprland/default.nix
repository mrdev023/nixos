{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.desktop.hyprland;

  set_volume = pkgs.writeScriptBin "set_volume.sh" ''
    #!${pkgs.runtimeShell}
    pactl set-sink-volume @DEFAULT_SINK@ $1 && $send_volume_notif notify-send "Volume" -h int:value:"$(pactl get-sink-volume @DEFAULT_SINK@ | cut -d ' ' -f6 | cut -d '%' -f1)"
  '';
in
{
  options.modules.home.desktop.hyprland = {
    enable = mkEnableOption ''
      Enable hyprland with my custom configurations
    '';
  };
  config = mkIf cfg.enable (mkMerge [
    (import ./programs/dunst/default.nix)
    (import ./programs/waybar/default.nix)
    {
      modules.home.apps.kitty.enable = mkDefault true;

      home.packages = with pkgs; [
        dunst
        hyprpicker
        hyprpicker
        networkmanagerapplet
        playerctl
        waybar
      ];

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
        configPackages = [ config.wayland.windowManager.hyprland.package ];
        config.hyprland = {
          default = [ "hyprland" ];
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;

        plugins = with pkgs.hyprlandPlugins; [
          hyprsplit
        ];

        systemd = {
          enable = true;
          variables = [ "--all" ];
        };

        settings = {
          "$mainMod" = "SUPER";

          exec-once = [
            "waybar"
          ];

          env = [
            "XCURSOR_SIZE,24"
          ];

          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
          input = {
            kb_layout = "us";
            kb_variant = "altgr-intl";
            kb_model = "";
            kb_options = "";
            kb_rules = "";

            follow_mouse = 1;
            numlock_by_default = 1;

            touchpad = {
              natural_scroll = "no";
              disable_while_typing = "yes";
              tap-to-click = "yes";
            };

            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          };

          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 3;

            layout = "dwindle";
          };

          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          decoration = {
            rounding = 10;

            blur = {
              enabled = true;
              size = 3;
              passes = 1;
            };

            shadow = {
              enabled = true;
              range = 15;
              render_power = 4;
            };
          };

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          animations = {
            enabled = "yes";

            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          dwindle = {
            pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = "yes"; # you probably want this
          };

          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          master = {
            new_status = "master";
          };

          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gesture = [
            "3, horizontal, workspace"
          ];

          bind = [
            # "SUPERSHIFT,R,hyprload,reload"
            # "SUPERSHIFT,U,hyprload,update"

            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            "$mainMod, RETURN, exec, kitty"
            "$mainMod, C, killactive,"
            "$mainMod SHIFT, C, exec, hyprpicker -a -f hex"
            "$mainMod SHIFT, Q, exit,"
            "$mainMod, E, exec, nautilus"
            "$mainMod, V, togglefloating,"
            "$mainMod, F, fullscreen, 0"
            "$mainMod, D, exec, wofi -i -s ~/.config/hypr/wofi/style.css --show drun"
            "$mainMod, P, pseudo," # dwindle
            "$mainMod, B, togglesplit," # dwindle

            # Move focus with mainMod + arrow keys
            "$mainMod, h, movefocus, l"
            "$mainMod, l, movefocus, r"
            "$mainMod, j, movefocus, u"
            "$mainMod, k, movefocus, d"

            "$mainMod SHIFT_L, h, movewindow, l"
            "$mainMod SHIFT_L, l, movewindow, r"
            "$mainMod SHIFT_L, j, movewindow, u"
            "$mainMod SHIFT_L, k, movewindow, d"

            "$mainMod ALT_L, v, exec, dunstctl context"
            "$mainMod ALT_L, c, exec, dunstctl close-all"
            "$mainMod ALT_L, x, exec, dunstctl close"

            # Switch workspaces with mainMod + [0-9]
            "$mainMod, 1, split:workspace, 1"
            "$mainMod, 2, split:workspace, 2"
            "$mainMod, 3, split:workspace, 3"
            "$mainMod, 4, split:workspace, 4"
            "$mainMod, 5, split:workspace, 5"
            "$mainMod, 6, split:workspace, 6"
            "$mainMod, 7, split:workspace, 7"
            "$mainMod, 8, split:workspace, 8"
            "$mainMod, 9, split:workspace, 9"
            "$mainMod, 0, split:workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "$mainMod SHIFT, 1, split:movetoworkspace, 1"
            "$mainMod SHIFT, 2, split:movetoworkspace, 2"
            "$mainMod SHIFT, 3, split:movetoworkspace, 3"
            "$mainMod SHIFT, 4, split:movetoworkspace, 4"
            "$mainMod SHIFT, 5, split:movetoworkspace, 5"
            "$mainMod SHIFT, 6, split:movetoworkspace, 6"
            "$mainMod SHIFT, 7, split:movetoworkspace, 7"
            "$mainMod SHIFT, 8, split:movetoworkspace, 8"
            "$mainMod SHIFT, 9, split:movetoworkspace, 9"
            "$mainMod SHIFT, 0, split:movetoworkspace, 10"

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          binde = [
            "$mainMod CTRL_L, h, resizeactive, -50 0"
            "$mainMod CTRL_L, l, resizeactive, 50 0"
            "$mainMod CTRL_L, j, resizeactive, 0 -50"
            "$mainMod CTRL_L, k, resizeactive, 0 50"

            # Use pactl to adjust volume in PulseAudio.
            ", XF86AudioRaiseVolume, exec, ${set_volume} \"+5%\""
            ", XF86AudioLowerVolume, exec, ${set_volume} \"-5%\""
          ];

          bindl = [
            ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
            ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"

            # Media player controls
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioNext, exec, playerctl next"

            # Screen brightness controls
            ", XF86MonBrightnessUp, exec, xbacklight -inc 5"
            ", XF86MonBrightnessDown, exec, xbacklight -dec 5"
          ];
        };
      };
    }
  ]);
}
