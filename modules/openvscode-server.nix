{ config, pkgs, ... }:

{
  services.openvscode-server = {
    enable = true;
    host = "0.0.0.0";
    user = "florian";
    withoutConnectionToken = true;
    telemetryLevel = "off";
  };
}
