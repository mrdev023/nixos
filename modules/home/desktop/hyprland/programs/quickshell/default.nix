{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings.exec-once = [
    "quickshell -p ${./qml}/shell.qml"
  ];
  home = {
    packages = with pkgs; [
      quickshell
      cliphist
      wl-clipboard
      libnotify
    ];
    file.".config/quickshell/colors.json".source = config.stylix.generated.json;
    file.".config/quickshell/variables.json".text = builtins.toJSON (import ../../variables.nix);
    file.".config/quickshell/fonts.json".text =
      let
        fonts = config.stylix.fonts;
        mapFonts =
          fontNames:
          builtins.listToAttrs (
            map (fontName: {
              name = fontName;
              value = fonts.${fontName}.name;
            }) fontNames
          );

        fontNames = mapFonts [
          "emoji"
          "monospace"
          "serif"
          "sansSerif"
        ];
      in
      builtins.toJSON (
        {
          inherit (fonts) sizes;

        }
        // fontNames
      );
  };
}
