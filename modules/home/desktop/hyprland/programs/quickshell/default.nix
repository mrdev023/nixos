{ pkgs, ... }:

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
      qt6.qtsvg
    ];
  };
}
