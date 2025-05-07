{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.editors.vscode;
in
{
  options.modules.home.editors.vscode = {
    enable = mkEnableOption ''
      Enable vscode with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    # Inspired by https://github.com/khaneliman/khanelinix/blob/1cc1ff0435671804666cdc732a0b792178441e2f/modules/home/programs/graphical/editors/vscode/default.nix
    programs.vscode = {
      enable = true;

      profiles =
        let
          commonExtensions = with pkgs.vscode-extensions; [
            # Direnv to automatically Load Dev Env
            mkhl.direnv

            # Nix
            bbenoist.nix

            # Improve error display
            usernamehw.errorlens
          ];

          commonSettings = {
            "files.autoSave" = "onFocusChange";
            "git.autofetch" = true;
          };
        in rec {
          default = {
            extensions = commonExtensions;
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;
            userSettings = commonSettings;
          };

          C_CPP = {
            extensions =
              with pkgs.vscode-extensions;
              commonExtensions
                ++ [ ms-vscode.cpptools ms-vscode.cmake-tools ms-vscode.cpptools-extension-pack ];
          };

          C_Sharp = {
            extensions =
              with pkgs.vscode-extensions;
              commonExtensions
                ++ [ ms-dotnettools.csdevkit ms-dotnettools.csharp ms-dotnettools.vscode-dotnet-runtime ];
          };

          UnrealEngine = {
            extensions =
              commonExtensions
                ++ C_CPP.extensions
                ++ C_Sharp.extensions;
          };

          Phoenix = {
            extensions =
              with pkgs.vscode-extensions;
              commonExtensions
                ++ [ phoenixframework.phoenix elixir-lsp.vscode-elixir-ls ];

            userSettings = commonSettings // {
              "emmet.includeLanguages" = {
                "phoenix-heex" = "html";
              };
            };
          };

          Ruby = {
            extensions =
              with pkgs.vscode-extensions;
              commonExtensions
                ++ [ shopify.ruby-lsp ];
          };

          Rust = {
            extensions =
              with pkgs.vscode-extensions;
              commonExtensions
                ++ [ tamasfe.even-better-toml rust-lang.rust-analyzer ];
          };

          Typescript = {
            extensions =
              with pkgs.vscode-extensions;
              commonExtensions
                ++ [ yoavbls.pretty-ts-errors ];
          };
        };
    };
  };
}