{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  utils = import ./utils.nix { inherit config lib; };
  inherit (utils) cfgHasLanguage cfgHasAnyOfLanguages;
in
{
  config.programs.zed-editor = mkMerge [
    {
      userSettings = {
        telemetry.metrics = false;
        helix_mode = true;
        terminal.shell.program = "zsh";
        load_direnv = "shell_hook";
      };
    }

    (mkIf
      (cfgHasAnyOfLanguages [
        "c_cpp"
        "rust"
        "zig"
      ])
      {
        extraPackages = with pkgs; [ lldb ];
      }
    )

    # Graphics API
    (mkIf (cfgHasLanguage "wgsl") {
      extensions = [ "wgsl" ];
      extraPackages = with pkgs; [ wgsl-analyzer ];
    })
    (mkIf (cfgHasLanguage "glsl") {
      extensions = [ "wgsl-wesl" ];
      extraPackages = with pkgs; [ glsl_analyzer ];
    })

    # System
    (mkIf (cfgHasLanguage "c_cpp") {
      extraPackages = with pkgs; [ clang-tools ];
    })
    (mkIf (cfgHasLanguage "rust") {
      extraPackages = with pkgs; [
        rust-analyzer
        clippy
      ];
    })

    # Autres
    (mkIf (cfgHasLanguage "zig") {
      extraPackages = with pkgs; [
        zig
        zls
      ];
    })
    (mkIf (cfgHasLanguage "nix") {
      extensions = [ "nix" ];
      extraPackages = with pkgs; [
        nil
        nixd
        nixfmt
      ];
    })
  ];
}
