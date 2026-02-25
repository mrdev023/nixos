{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfgTop = config.modules.home.editors;
  cfg = cfgTop.helix;

  utils = import ./utils.nix {
    config = cfgTop;
    lib = lib;
  };
  inherit (utils) cfgHasLanguage cfgHasAnyOfLanguages;
in
{
  options.modules.home.editors.helix = {
    enable = mkEnableOption ''
      Enable helix with my custom configurations
    '';
  };
  config.programs.helix = mkIf cfg.enable (mkMerge [
    {
      enable = true;
      settings = {
        theme = "tokyonight";

        editor = {
          bufferline = "always";
          line-number = "relative";

          cursor-shape.insert = "bar";
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
      }
    )
    (mkIf
      (cfgHasAnyOfLanguages [
        "html"
        "markdown"
      ])
      {
        extraPackages = with pkgs; [ prettier ];
      }
    )
    (mkIf
      (cfgHasAnyOfLanguages [
        "html"
        "css"
      ])
      {
        extraPackages = with pkgs; [ vscode-langservers-extracted ];
      }
    )
    (mkIf
      (cfgHasAnyOfLanguages [
        "html"
        "css"
        "js_ts"
      ])
      {
        extraPackages = with pkgs; [ tailwindcss-language-server ];
      }
    )
    (mkIf
      (cfgHasAnyOfLanguages [
        "css"
        "js_ts"
      ])
      {
        extraPackages = with pkgs; [
          biome
        ];

        languages.language-server.biome = {
          command = "biome";
          args = [ "lsp-proxy" ];
        };
      }
    )

    # "Web - Front"
    (mkIf (cfgHasLanguage "html") {
      languages.language = [
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
      ];
    })
    (mkIf (cfgHasLanguage "css") {
      languages.language = [
        {
          name = "css";
          language-servers = [
            "vscode-css-language-server"
            "tailwindcss-ls"
            "biome"
          ];
          auto-format = true;
        }
      ];
    })
    (mkIf (cfgHasLanguage "js_ts") {
      extraPackages = with pkgs; [
        typescript
        nodePackages.typescript-language-server
      ];

      languages = {
        language-server.typescript-language-server.config.tsserver = {
          path = "${pkgs.typescript}/lib/node_modules/typescript/lib/tsserver.js";
        };

        language = [
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
        ];
      };
    })

    # Web - backend
    (mkIf (cfgHasLanguage "php") {
      extraPackages = with pkgs; [ phpactor ];

      languages = {
        language-server.phpactor = {
          command = "phpactor";
          args = [ "language-server" ];
        };

        language = [
          {
            name = "php";
            language-servers = [ "phpactor" ];
            auto-format = true;
          }
        ];
      };
    })
    (mkIf (cfgHasLanguage "ruby") {
      extraPackages = with pkgs; [
        ruby-lsp
        rubyPackages.solargraph
      ];
    })
    (mkIf (cfgHasLanguage "java") {
      extraPackages = with pkgs; [ jdt-language-server ];
    })
    (mkIf (cfgHasLanguage "kotlin") {
      extraPackages = with pkgs; [ kotlin-language-server ];
    })
    (mkIf (cfgHasLanguage "sql") {
      extraPackages = with pkgs; [ sql-formatter ];

      languages.language = [
        {
          name = "sql";
          formatter = {
            command = "sql-formatter";
            args = [
              "-l"
              "postgresql"
            ];
          };
          auto-format = true;
        }
      ];
    })

    # Datascience
    (mkIf (cfgHasLanguage "python") {
      extraPackages = with pkgs; [
        ruff
        (python3.withPackages (
          p:
          (with p; [
            python-lsp-ruff
            python-lsp-server
          ])
        ))
      ];

      languages.language = [
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
      ];
    })

    # DevOps
    (mkIf (cfgHasLanguage "terraform") {
      extraPackages = with pkgs; [ terraform-ls ];
    })
    (mkIf (cfgHasLanguage "helm") {
      extraPackages = with pkgs; [ helm-ls ];
    })
    (mkIf (cfgHasLanguage "bash") {
      extraPackages = with pkgs; [ bash-language-server ];
    })
    (mkIf (cfgHasLanguage "go") {
      extraPackages = with pkgs; [
        golangci-lint
        golangci-lint-langserver
        gopls
        gotools
      ];

      languages.language = [
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
      ];
    })

    # Mobile
    (mkIf (cfgHasLanguage "dart") {
      extraPackages = with pkgs; [ dart ];
    })

    # Graphics API
    (mkIf (cfgHasLanguage "wgsl") {
      extraPackages = with pkgs; [ wgsl-analyzer ];
    })
    (mkIf (cfgHasLanguage "glsl") {
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

      languages = {
        language-server.rust-analyzer.config.check = {
          command = "clippy";
        };

        language = [
          {
            name = "rust";
            language-servers = [ "rust-analyzer" ];
            auto-format = true;
          }
        ];
      };
    })
    (mkIf (cfgHasLanguage "c_cpp") {
      extraPackages = with pkgs; [ clang-tools ];
    })

    # Autres
    (mkIf (cfgHasLanguage "zig") {
      extraPackages = with pkgs; [
        zig
        zls
      ];
    })
    (mkIf (cfgHasLanguage "nix") {
      extraPackages = with pkgs; [
        nil
        nixd
        nixfmt
      ];

      languages.language = [
        {
          name = "nix";
          formatter = {
            command = "nixfmt";
          };
          auto-format = true;
        }
      ];
    })
    (mkIf (cfgHasLanguage "markdown") {
      extraPackages = with pkgs; [
        marksman
      ];

      languages.language = [
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
      ];
    })
  ]);
}
