{ pkgs, lib, ... }:

with lib;
let
  wpctl = getExe' pkgs.wireplumber "wpctl";
  notify-send = getExe pkgs.libnotify;

  change-volume = pkgs.writeShellScriptBin "change_volume" ''
    action=$1
    shift

    function notify-volume() {
      current_volume=$(LC_ALL=C ${wpctl} get-volume @DEFAULT_SINK@)
      if echo "$current_volume" | grep -qi "muted"; then
        ${notify-send} -u low "Volume" -h int:value:0
      else
        current_volume=$(echo "$current_volume" | awk '{print int($2 * 100)}')
        ${notify-send} -u low "Volume" -h int:value:"$current_volume"
      fi
    }

    if [[ $action == "set_volume" ]]; then
      ${wpctl} set-volume @DEFAULT_SINK@ $1 && notify-volume
    elif [[ $action == "toggle_mute" ]]; then
      ${wpctl} set-mute @DEFAULT_SINK@ toggle && notify-volume
    else
      echo "Unknown action. Please use set_volume or toggle_mute action."
    fi
  '';
in
{
  raiseVolume = "${getExe change-volume} set_volume \"5%+\"";
  lowerVolume = "${getExe change-volume} set_volume \"5%-\"";
  toggleMute = "${getExe change-volume} toggle_mute";
}
