{
  config,
  pkgs,
  lib,
  ...
}@args:

with lib;
let
  cfg = config.modules.home.desktop.hyprland;
  variables = import ./variables.nix;

  hyprsplit = pkgs.hyprlandPlugins.hyprsplit.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "shezdy";
      repo = "hyprsplit";
      rev = "v0.54.1";
      hash = "sha256-IksjbT24cgWl2h6ZV4bPxoORmHCQ7h/M/OLQ4epReAE=";
    };
  };
in
{
  options.modules.home.desktop.hyprland = {
    enable = mkEnableOption ''
      Enable hyprland with my custom configurations
    '';
  };
  config = mkIf cfg.enable (mkMerge [
    (import ./programs/stylix/default.nix args)
    (import ./programs/dunst/default.nix args)
    (import ./programs/hyprpaper/default.nix args)
    (import ./programs/waybar/default.nix args)
    (import ./programs/wofi/default.nix args)
    {
      programs.kitty.enable = mkDefault true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
        ];
        xdgOpenUsePortal = true;
        configPackages = [ config.wayland.windowManager.hyprland.package ];
        config.hyprland = {
          default = [ "hyprland" ];
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;

        plugins = [
          hyprsplit
        ];

        systemd = {
          enable = true;
          variables = [ "--all" ];
        };

        settings = rec {
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
              "$mainMod, V, togglefloating,"
              "$mainMod, F, fullscreen, 0"
              "$mainMod, T, pin, active"
              # Already installed with programs.wofi.enable = true;
              "$mainMod, D, exec, wofi -i -s ~/.config/wofi/style.css --show drun"
              ", Print, exec, ${screenshot.fullscreen}"
              "SHIFT, Print, exec, ${screenshot.region}"

              # Move focus with mainMod + arrow keys
              "$mainMod, h, movefocus, l"
              "$mainMod, l, movefocus, r"
              "$mainMod, j, movefocus, u"
              "$mainMod, k, movefocus, d"

              "$mainMod SHIFT_L, h, movewindow, l"
              "$mainMod SHIFT_L, l, movewindow, r"
              "$mainMod SHIFT_L, j, movewindow, u"
              "$mainMod SHIFT_L, k, movewindow, d"
              "$mainMod SHIFT_L, s, swapnext,"

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

          binde =
            let
              volume = (import ./scripts/volume.nix args);
            in
            [
              "$mainMod CTRL_L, h, resizeactive, -50 0"
              "$mainMod CTRL_L, l, resizeactive, 50 0"
              "$mainMod CTRL_L, j, resizeactive, 0 -50"
              "$mainMod CTRL_L, k, resizeactive, 0 50"

              # Use pactl to adjust volume in PulseAudio.
              ", XF86AudioRaiseVolume, exec, ${volume.raiseVolume}"
              ", XF86AudioLowerVolume, exec, ${volume.lowerVolume}"
            ];

          bindl =
            let
              volume = (import ./scripts/volume.nix args);
              player = (import ./scripts/player.nix args);
              backlight = (import ./scripts/backlight.nix args);
            in
            [
              ", XF86AudioMute, exec, ${volume.toggleMute}"
              # ", XF86AudioMicMute, exec, ${toggleMute}"

              # Media player controls
              ", XF86AudioPlay, exec, ${player.play}"
              ", XF86AudioPause, exec, ${player.pause}"
              ", XF86AudioPrev, exec, ${player.previous}"
              ", XF86AudioNext, exec, ${player.next}"

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
              name = "set-pavucontrol-to-float";
              "match:initial_class" = "org.pulseaudio.pavucontrol";
              float = "on";
            }
            {
              name = "set-overskride-to-float";
              "match:initial_class" = "io.github.kaii_lb.Overskride";
              float = "on";
            }
            {
              name = "set-nmtui-to-float";
              "match:initial_title" = "nmtui";
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
          ];
        };
      };
    }
  ]);
}
