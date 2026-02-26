{ config, lib, ... }:

with lib;
let
  cfg = config.modules.home.shell.television;
in
{
  options.modules.home.shell.television = {
    enable = mkEnableOption ''
      Enable television with my custom configurations
    '';

    defaultChannel = mkOption {
      type = types.nullOr types.str;
      default = if length cfg.channels > 0 then head cfg.channels else null;
      description = "Set the default channel used with tv command";
    };

    channels = mkOption {
      type = types.listOf (
        types.enum [
          "nix-search-tv"
        ]
      );
      default = [ ];
      description = "List of channels to enable.";
    };
  };
  config = mkIf cfg.enable {
    programs.television = {
      enable = true;

      settings = {
        tick_rate = 50;
        default_channel = mkIf (cfg.defaultChannel != null) cfg.defaultChannel;
        ui = {
          use_nerd_font_icons = true;
        };
      };
    };

    programs.nix-search-tv = mkIf (elem "nix-search-tv" cfg.channels) {
      enable = true;

      settings = {
        indexes = [
          "nixpkgs"
          "home-manager"
          "nixos"
          "nur"
        ];

        experimental = {
          render_docs_indexes = {
            nvf = "https://notashelf.github.io/nvf/options.html";
          };
        };
      };
    };
  };
}
