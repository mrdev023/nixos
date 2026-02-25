{
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.home.editors;

  allLanguages = [
    # "Web - Frontend"
    "html"
    "css"
    "js_ts"

    # Web - backend
    "php"
    "ruby"
    "java"
    "kotlin"
    "sql"

    # Datascience
    "python"

    # DevOps
    "terraform"
    "helm"
    "bash"
    "go"

    # Mobile
    "dart"

    # Graphics API
    "wgsl"
    "glsl"

    # System
    "rust"
    "c_cpp"

    # Autres
    "zig"
    "nix"
    "markdown"
  ];
in
{
  imports = [
    ./helix.nix
    ./neovim.nix
    ./vscode.nix
  ];

  options.modules.home.editors = {
    profiles = mkOption {
      description = ''
        Chaque profile permet de rajouter une liste languages pour ce profile
      '';
      default = [ ];
      example = ''
        [ "web" "system" ]
      '';
      type = types.listOf (
        types.enum [
          "common"
          "web"
          "mobile"
          "system"
          "devops"
          "graphics"
        ]
      );
    };
    extraLanguages = mkOption {
      description = ''
        Language supplémentaire en plus des profiles
      '';
      default = [ "all" ];
      example = ''
        [ "java" "js_ts" "rust" ] or [ "all" ]
      '';
      type = types.listOf (types.enum (allLanguages ++ [ "all" ]));
    };
    languages = mkOption {
      description = ''
        Liste des languages. (interne uniquement)
      '';
      default = [ ];
      example = ''
        [ "java" "js_ts" "rust" ]
      '';
      type = types.listOf (types.enum allLanguages);
    };
  };

  config.modules.home.editors = {
    languages =
      let
        languages =
          cfg.extraLanguages
          ++ optionals (elem "common" cfg.profiles) [
            "markdown"
            "nix"
            "bash"
          ]
          ++ optionals (elem "web" cfg.profiles) [
            "html"
            "css"
            "js_ts"
          ]
          ++ optionals (elem "mobile" cfg.profiles) [
            # Android
            "java"
            "kotlin"
            # Flutter
            "dart"
          ]
          ++ optionals (elem "system" cfg.profiles) [
            "rust"
            "c_cpp"
          ]
          ++ optionals (elem "devops" cfg.profiles) [
            "terraform"
            "helm"
            "bash"
            "go"
          ]
          ++ optionals (elem "graphics" cfg.profiles) [
            "wgsl"
            "glsl"
          ];
      in
      if (elem "all" cfg.extraLanguages) then unique allLanguages else unique languages;
  };
}
