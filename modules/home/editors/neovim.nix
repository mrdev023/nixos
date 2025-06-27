{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.home.editors.neovim;
in {
  options.modules.home.editors.neovim = {
    enable = mkEnableOption ''
      Enable neovim with my custom configurations
    '';
  };
  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      enableManpages = true;

      # https://notashelf.github.io/nvf/options.html
      settings.vim = {
        viAlias = true;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        options = {
          tabstop = 2;
          shiftwidth = 2;
        };

        spellcheck = {
          enable = true;
        };

        clipboard = {
          enable = true;

          providers = {
            wl-copy.enable = true;
          };
        };

        lsp = {
          enable = true;
          formatOnSave = false;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          lspSignature.enable = true;
          trouble.enable = true;
          otter-nvim.enable = true;
          nvim-docs-view.enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        languages = {
          enableDAP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          bash.enable = true;
          clang = {
            # C++
            enable = true;
            dap.enable = true;
            lsp.enable = true;
          };
          css.enable = true;
          dart = {
            enable = true;
            flutter-tools = {
              enable = true;
              enableNoResolvePatch = true;
              color = {
                enable = true;
                highlightBackground = true;
                highlightForeground = true;
                virtualText.enable = true;
              };
            };
          };
          html.enable = true;
          java.enable = true;
          kotlin.enable = true;
          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
          };
          nix.enable = true;
          php.enable = true;
          python.enable = true;
          ruby.enable = true;
          rust = {
            enable = true;
            crates.enable = true;
          };
          sql.enable = true;
          tailwind.enable = true;
          ts = {
            enable = true;
            extensions.ts-error-translator.enable = false;
          };
          wgsl.enable = true;
          zig.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;

          highlight-undo.enable = true;
          indent-blankline.enable = true;

          # Fun
          cellular-automaton.enable = false;
        };

        statusline = {
          lualine = {
            enable = true;
            theme = "catppuccin";
          };
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = false;
        };

        autopairs.nvim-autopairs.enable = true;

        autocomplete.nvim-cmp.enable = true;
        snippets.luasnip.enable = true;

        filetree = {
          neo-tree = {
            enable = true;
            setupOpts = {
              git_status_async = true;
            };
          };
        };

        tabline = {
          nvimBufferline.enable = true;
        };

        treesitter = {
          context.enable = true;
        };

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        telescope.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false; # throws an annoying debug message
        };

        minimap = {
          minimap-vim.enable = false;
          codewindow.enable = true; # lighter, faster, and uses lua for configuration
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        projects = {
          project-nvim.enable = true;
        };

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          icon-picker.enable = true;
          surround.enable = true;
          diffview-nvim.enable = true;
          yanky-nvim.enable = false;
          motion = {
            hop.enable = true;
            leap.enable = true;
            precognition.enable = false; # VIM help
          };

          images = {
            image-nvim.enable = false;
          };
        };

        notes = {
          obsidian.enable = false;
          neorg.enable = false;
          orgmode.enable = false;
          mind-nvim.enable = true;
          todo-comments.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = true;
          modes-nvim.enable = false; # the theme looks terrible with catppuccin
          illuminate.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          smartcolumn = {
            enable = true;
            setupOpts.custom_colorcolumn = {
              # this is a freeform module, it's `buftype = int;` for configuring column position
              nix = "110";
              ruby = "120";
              java = "130";
              go = ["90" "130"];
            };
          };
          fastaction.enable = true;
        };

        assistant = {
          avante-nvim = {
            enable = true;
            setupOpts = {
              auto_suggestions_provider = "mistral_devstral";
              provider = "mistral_devstral";
              providers = {
                mistral_devstral = {
                  __inherited_from = "openai";
                  api_key_name = "MISTRAL_API_KEY";
                  endpoint = "https://api.mistral.ai/v1/";
                  model = "devstral-small-latest";
                  extra_request_body = {
                    max_tokens = 32768;
                  };
                };
              };
            };
          };
        };

        session = {
          nvim-session-manager.enable = false;
        };

        gestures = {
          gesture-nvim.enable = true;
        };

        comments = {
          comment-nvim.enable = true;
        };

        presence = {
          neocord.enable = true;
        };
      };
    };
  };
}
