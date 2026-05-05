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
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        helix_mode = true;
        terminal.shell.program = "zsh";
        load_direnv = "direct";
        inlay_hints.enabled = true;
        theme = {
          mode = "system";
          light = "One Light";
          dark = "One Dark";
        };
        icon_theme = {
          mode = "system";
          light = "Zed (Default)";
          dark = "Zed (Default)";
        };
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
        userSettings.dap.CodeLLDB.binary = getExe' pkgs.lldb "lldb-dap";
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

    (mkIf (cfgHasLanguage "java") {
      extensions = [ "java" ];
      extraPackages = with pkgs; [ jdt-language-server ];
      userSettings.lsp.jdtls.binary.path = getExe pkgs.jdt-language-server;
    })
    (mkIf (cfgHasLanguage "kotlin") {
      extraPackages = with pkgs; [ kotlin-language-server ];
      userSettings.lsp.kotlin-language-server.binary.path = getExe pkgs.kotlin-language-server;
    })

    # System
    (mkIf (cfgHasLanguage "c_cpp") {
      extensions = [ "neocmake" ];
      extraPackages = with pkgs; [
        clang-tools
        cmake-language-server
        gersemi
      ];
      userSettings.languages = {
        "C" = {
          formatter = {
            external = {
              command = "clang-format";
              arguments = [
                "--style=file"
                "--assume-filename={buffer_path}"
              ];
            };
          };
          format_on_save = "on";
        };
        "C++" = {
          formatter = {
            external = {
              command = "clang-format";
              arguments = [
                "--style=file"
                "--assume-filename={buffer_path}"
              ];
            };
          };
          format_on_save = "on";
        };
        "CMake" = {
          formatter = {
            external = {
              command = "gersemi";
              arguments = [ "-" ];
            };
          };
          format_on_save = "on";
        };
      };
    })
    (mkIf (cfgHasLanguage "qml") {
      extensions = [ "qml" ];
      extraPackages = with pkgs.kdePackages; [
        qtdeclarative
      ];
      userSettings.lsp.qml.binary = {
        path = getExe' pkgs.kdePackages.qtdeclarative "qmlls";
        arguments = [ "-E" ];
      };
    })
    (mkIf (cfgHasLanguage "rust") {
      extraPackages = with pkgs; [
        rust-analyzer
        clippy
      ];
      userSettings.lsp.rust-analyzer.binary.path = getExe pkgs.rust-analyzer;
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
