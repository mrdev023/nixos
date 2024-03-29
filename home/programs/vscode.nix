{ config, pkgs, ... }:

{
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
}