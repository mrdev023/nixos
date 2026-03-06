{ pkgs, lib, ... }:

with lib;
let
  pactl = getExe' pkgs.pulseaudio "pactl";
  notify-send = getExe pkgs.libnotify;

  change_volume = pkgs.writeShellScriptBin "change_volume" ''
    action=$1
    shift

    function get_volume() {
      ${pactl} get-sink-volume @DEFAULT_SINK@ | cut -d ' ' -f6 | cut -d '%' -f1
    }

    function notify_volume() {
      if [[ "$1" == "muted" ]]; then
        ${notify-send} "Volume" -h int:value:"0"
      else
        volume=$(get_volume)
        ${notify-send} "Volume" -h int:value:"$volume"
      fi
    }

    function set_volume() {
      ${pactl} set-sink-volume @DEFAULT_SINK@ $1 && notify_volume
    }

    function toggle_mute() {
      ${pactl} set-sink-mute @DEFAULT_SINK@ toggle
      muted=$(LC_ALL=C ${pactl} get-sink-mute @DEFAULT_SINK@ | grep -q "yes")
      if $muted; then
        notify_volume muted
      else
        notify_volume
      fi
    }

    if [[ $action == "set_volume" ]]; then
      set_volume $1
    elif [[ $action == "toggle_mute" ]]; then
      toggle_mute
    else
      echo "Unknown action. Please use set_volume or toggle_mute action."
    fi
  '';
in
{
  raiseVolume = "${getExe change_volume} set_volume \"+5%\"";
  lowerVolume = "${getExe change_volume} set_volume \"-5%\"";
  toggleMute = "${getExe change_volume} toggle_mute";
}
