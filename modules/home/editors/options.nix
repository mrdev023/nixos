{ lib, ... }:

with lib;
let
  availableLanguages = [
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
  options.modules.home.editors = {
    languages = mkOption {
      description = ''
        Liste des languages. (interne uniquement)
      '';
      default = availableLanguages;
      example = ''
        [ "java" "js_ts" "rust" ]
      '';
      type = types.listOf (types.enum availableLanguages);
    };
  };
}
