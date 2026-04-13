{
  config,
  pkgs,
  lib,
  ...
}@args:

with lib;
let
  cfg = config.wayland.windowManager.hyprland;
  variables = import ./variables.nix;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enable -> config.stylix.enable;
          message = "Hyprland requires stylix to be enabled too";
        }
      ];
    }
    # (import ./programs/dunst.nix args)
    # (import ./programs/hyprlock.nix args)
    (import ./programs/hyprpaper.nix args)
    (import ./programs/quickshell args)
    # (import ./programs/waybar.nix args)
    # (import ./programs/wofi.nix args)
    {
      programs.kitty.enable = mkDefault true;

      home.packages = with pkgs; [
        # Required by clipboard script and hyprpicker
        wl-clipboard
      ];

      services.gnome-keyring = {
        enable = true;
        components = [
          "pkcs11"
          "secrets"
        ];
      };

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
        configPackages = [ config.wayland.windowManager.hyprland.finalPackage ];
        config = {
          hyprland = {
            default = [
              "hyprland"
              "gtk"
            ];

            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
          };

          common.default = [ "gtk" ];
        };
      };

      wayland.windowManager.hyprland = {
        plugins = with pkgs.hyprlandPlugins; [
          hyprsplit
        ];

        systemd = {
          enable = true;
          variables = [ "--all" ];
        };

        settings = rec {
          "$mainMod" = "SUPER";

          exec-once =
            let
              clipboard = import ./scripts/clipboard.nix args;
            in
            [
              clipboard.watch
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
            # Applied for each side of window so need to divide by 2
            gaps_in = variables.window.gap / 2;
            gaps_out = variables.window.gap;
            border_size = variables.window.border.size;

            layout = "scrolling";

            snap.enabled = true;
          };

          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          decoration = {
            active_opacity = 0.95;
            inactive_opacity = 0.75;
            fullscreen_opacity = 1.0;
            rounding = variables.window.border.radius;

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

          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          master = {
            new_status = "master";
          };

          # See https://wiki.hyprland.org/Configuring/Variables/#group for more
          group = {
            groupbar = {
              font_size = 10;
              height = 16;
              gradients = false;
              render_titles = true;
              scrolling = true;
            };
          };

          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gesture = [
            "3, horizontal, workspace"
          ];

          bind =
            let
              screenshot = import ./scripts/screenshot.nix args;
            in
            [
              # "SUPERSHIFT,R,hyprload,reload"
              # "SUPERSHIFT,U,hyprload,update"

              # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
              "$mainMod, RETURN, exec, kitty"
              "$mainMod, C, killactive,"
              "$mainMod SHIFT, C, exec, ${getExe pkgs.hyprpicker} -a -f hex"
              "$mainMod SHIFT, Q, exit,"
              "$mainMod, E, exec, ${getExe pkgs.nautilus}"
              "$mainMod, G, togglefloating,"
              "$mainMod, F, fullscreen, 0"
              "$mainMod, T, pin, active"
              "$mainMod, D, global, quickshell:launcher_toggle"
              ", Print, exec, ${screenshot.fullscreen}"
              "SHIFT, Print, exec, ${screenshot.region}"
              "$mainMod, V, global, quickshell:clipboard_toggle"
              "$mainMod SHIFT, V, global, quickshell:clipboard_wipe"
              "Control, L, global, quickshell:session_lock"

              # Move focus with mainMod + arrow keys
              "$mainMod, h, movefocus, l"
              "$mainMod, l, movefocus, r"
              "$mainMod, j, movefocus, u"
              "$mainMod, k, movefocus, d"

              "$mainMod SHIFT_L, h, swapwindow, l"
              "$mainMod SHIFT_L, l, swapwindow, r"
              "$mainMod SHIFT_L, j, swapwindow, u"
              "$mainMod SHIFT_L, k, swapwindow, d"

              # Group management
              "ALT_L, G, togglegroup,"
              "ALT_L, H, moveintogroup, l"
              "ALT_L, L, moveintogroup, r"
              "ALT_L, B, moveoutofgroup,"
              "ALT_L, bracketleft, changegroupactive, b"
              "ALT_L, bracketright, changegroupactive, f"

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
              "$mainMod ALT_L, h, split:workspace, e-1"
              "$mainMod ALT_L, l, split:workspace, e+1"

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

            ", XF86AudioRaiseVolume, global, quickshell:audio_up"
            ", XF86AudioLowerVolume, global, quickshell:audio_down"
            ", XF86AudioMute, global, quickshell:audio_mute_toggle"
            ", XF86AudioMicMute, global, quickshell:mic_mute_toggle"
          ];

          bindl =
            let
              backlight = (import ./scripts/backlight.nix args);
            in
            [
              # Media player controls
              ", XF86AudioPlay, global, quickshell:player_toggle"
              ", XF86AudioPause, global, quickshell:player_toggle"
              ", XF86AudioPrev, global, quickshell:player_previous"
              ", XF86AudioNext, global, quickshell:player_next"

              # Screen brightness controls
              ", XF86MonBrightnessUp, exec, ${backlight.inc}"
              ", XF86MonBrightnessDown, exec, ${backlight.dec}"
            ];

          windowrule = [
            {
              name = "no-set-active-opacity-for-zen";
              "match:initial_class" = "zen-beta";
              opacity = "1.0 override ${toString decoration.inactive_opacity} override ${toString decoration.fullscreen_opacity} override";
            }
            {
              name = "set-zen-pip-to-float";
              "match:initial_class" = "zen-beta";
              "match:initial_title" = "Incrustation vidéo";
              float = "on";
              pin = "on";
            }
            {
              name = "set-quickshell-to-float";
              "match:initial_class" = "org.quickshell";
              float = "on";
            }
            {
              name = "set_decoration_for_pinned_window";
              "match:pin" = true;
              border_size = general.border_size * 2;
            }
            {
              name = "focus_bitwarden_when_requested";
              "match:initial_class" = "Bitwarden";
              focus_on_activate = "on";
            }
            {
              name = "set-zen-bitwarden-extension-to-float";
              "match:class" = "zen-beta";
              "match:title" = ".*Bitwarden.*";
              float = "on";
            }
            {
              name = "set-screencapture-portal-to-float";
              "match:initial_title" = "Select what to share";
              float = "on";
            }
          ];
        };
      };
    }
  ]);
}
