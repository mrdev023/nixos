{
  config,
  lib,
  ...
}:

with lib;
let
  cfgFont = config.modules.home.shell.font;
  cfgStylix = config.stylix;
in
{
  config = {
    programs.kitty = mkMerge [
      {
        keybindings = {
          "ctrl+shift+enter" = "new_window_with_cwd";
          "ctrl+shift+t" = "new_tab_with_cwd";
        };

        settings = mkMerge [
          {
            disable_ligatures = "never";
            sync_to_monitor = "yes"; # Avoid to update a lot
            confirm_os_window_close = 0; # Disable close confirmation
            # hide_window_decorations = if pkgs.stdenv.hostPlatform.isDarwin then "titlebar-and-corners" else "yes";

            cursor_trail = 3;
            cursor_trail_decay = "0.1 0.4";
          }

          (mkIf config.programs.zsh.enable { shell = "zsh"; })
        ];
      }

      (mkIf (!cfgStylix.enable) {
        font.name = cfgFont.name;

        settings = {
          background_opacity = "0.7";
          background_blur = "1";
        };
      })
    ];
  };
}
