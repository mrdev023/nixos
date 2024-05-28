{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.home.apps.vscode;
in
{
  options.modules.home.apps.vscode = {
    enable = mkEnableOption ''
      Enable vscode with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      userSettings = {
        "files.autoSave" = "onFocusChange";
        "emmet.includeLanguages" = {
          "phoenix-heex" = "html";
        };
        "git.autofetch" = true;
      };

      userTasks = {};

      extensions = with pkgs; with vscode-extensions; [
        # Nix
        bbenoist.nix

        # Rust
        rust-lang.rust-analyzer
        serayuzgur.crates
        tamasfe.even-better-toml

        # Phoenix
        phoenixframework.phoenix
        elixir-lsp.vscode-elixir-ls

        # Ruby
        shopify.ruby-lsp
      ];
    };
  };
}