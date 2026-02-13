{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.editors.helix;
in
{
  options.modules.home.editors.helix = {
    enable = mkEnableOption ''
      Enable helix with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;

      extraPackages = with pkgs; [
        bash-language-server
        biome
        clang-tools
        docker-compose-language-service
        dockerfile-language-server
        golangci-lint
        golangci-lint-langserver
        gopls
        gotools
        marksman
        nil
        nixd
        nixfmt
        nodePackages.prettier
        nodePackages.typescript-language-server
        sql-formatter
        ruff
        (python3.withPackages (
          p:
          (with p; [
            python-lsp-ruff
            python-lsp-server
          ])
        ))
        rust-analyzer
        tailwindcss-language-server
        taplo
        terraform-ls
        typescript
        jdt-language-server
        vscode-langservers-extracted
        yaml-language-server
      ];

      settings = {
        theme = "tokyonight";

        editor = {
          bufferline = "always";
          line-number = "relative";

          cursor-shape.insert = "bar";
        };
      };

      languages = {
        language-server = {
          biome = {
            command = "biome";
            args = [ "lsp-proxy" ];
          };

          rust-analyzer.config.check = {
            command = "clippy";
          };

          yaml-language-server.config.yaml.schemas = {
            kubernetes = "k8s/*.yaml";
          };

          typescript-language-server.config.tsserver = {
            path = "${pkgs.typescript}/lib/node_modules/typescript/lib/tsserver.js";
          };
        };

        language = [
          {
            name = "css";
            language-servers = [
              "vscode-css-language-server"
              "tailwindcss-ls"
              "biome"
            ];
            auto-format = true;
          }
          {
            name = "go";
            language-servers = [
              "gopls"
              "golangci-lint-lsp"
            ];
            formatter = {
              command = "goimports";
            };
            auto-format = true;
          }
          {
            name = "html";
            language-servers = [
              "vscode-html-language-server"
              "tailwindcss-ls"
            ];
            formatter = {
              command = "prettier";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
            auto-format = true;
          }
          {
            name = "javascript";
            language-servers = [
              {
                name = "typescript-language-server";
                except-features = [ "format" ];
              }
              "biome"
            ];
            auto-format = true;
          }
          {
            name = "json";
            language-servers = [
              {
                name = "vscode-json-language-server";
                except-features = [ "format" ];
              }
              "biome"
            ];
            formatter = {
              command = "biome";
              args = [
                "format"
                "--indent-style"
                "space"
                "--stdin-file-path"
                "%{buffer_name}"
              ];
            };
            auto-format = true;
          }
          {
            name = "jsonc";
            language-servers = [
              {
                name = "vscode-json-language-server";
                except-features = [ "format" ];
              }
              "biome"
            ];
            formatter = {
              command = "biome";
              args = [
                "format"
                "--indent-style"
                "space"
                "--stdin-file-path"
                "%{buffer_name}"
              ];
            };
            file-types = [
              "jsonc"
              "hujson"
            ];
            auto-format = true;
          }
          {
            name = "jsx";
            language-servers = [
              {
                name = "typescript-language-server";
                except-features = [ "format" ];
              }
              "tailwindcss-ls"
              "biome"
            ];
            formatter = {
              command = "biome";
              args = [
                "format"
                "--indent-style"
                "space"
                "--stdin-file-path"
                "%{buffer_name}"
              ];
            };
            auto-format = true;
          }
          {
            name = "markdown";
            language-servers = [ "marksman" ];
            formatter = {
              command = "prettier";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
            auto-format = true;
          }
          {
            name = "nix";
            formatter = {
              command = "nixfmt";
            };
            auto-format = true;
          }
          {
            name = "python";
            language-servers = [
              "pylsp"
            ];
            formatter = {
              command = "sh";
              args = [
                "-c"
                "ruff check --select I --fix - | ruff format --line-length 88 -"
              ];
            };
            auto-format = true;
          }
          {
            name = "rust";
            language-servers = [ "rust-analyzer" ];
            auto-format = true;
          }
          {
            name = "sql";
            formatter = {
              command = "sql-formatter";
              args = [
                "-l"
                "postgresql"
                "-c"
                "{\"keywordCase\": \"lower\", \"dataTypeCase\": \"lower\", \"functionCase\": \"lower\", \"expressionWidth\": 120, \"tabWidth\": 4}"
              ];
            };
            auto-format = true;
          }
          {
            name = "toml";
            language-servers = [ "taplo" ];
            formatter = {
              command = "taplo";
              args = [
                "fmt"
                "-o"
                "column_width=120"
                "-"
              ];
            };
            auto-format = true;
          }
          {
            name = "tsx";
            language-servers = [
              {
                name = "typescript-language-server";
                except-features = [ "format" ];
              }
              "tailwindcss-ls"
              "biome"
            ];
            formatter = {
              command = "biome";
              args = [
                "format"
                "--indent-style"
                "space"
                "--stdin-file-path"
                "%{buffer_name}"
              ];
            };
            auto-format = true;
          }
          {
            name = "typescript";
            language-servers = [
              {
                name = "typescript-language-server";
                except-features = [ "format" ];
              }
              "biome"
            ];
            formatter = {
              command = "biome";
              args = [
                "format"
                "--indent-style"
                "space"
                "--stdin-file-path"
                "%{buffer_name}"
              ];
            };
            auto-format = true;
          }
          {
            name = "yaml";
            language-servers = [ "yaml-language-server" ];
            formatter = {
              command = "prettier";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
            auto-format = true;
          }
          {
            name = "java";
            language-servers = [ "jdtls" ];
            auto-format = true;
          }
        ];
      };
    };
  };
}
