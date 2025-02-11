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

        spellcheck = {
          enable = true;
        };

        lsp = {
          formatOnSave = true;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          trouble.enable = true;
          lspSignature.enable = true;
          otter-nvim.enable = true;
          lsplines.enable = true;
          nvim-docs-view.enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        languages = {
          enableLSP = true;
          enableDAP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          bash.enable = true;
          clang.enable = true; # C/C++
          css.enable = true;
          #         Not work currently. Crash during configuration of flutter-tools
          #          dart = {
          #            enable = true;
          #            flutter-tools = {
          #              enable = true;
          #              enableNoResolvePatch = true;
          #              color = {
          #                enable = true;
          #                highlightBackground = true;
          #                highlightForeground = true;
          #                virtualText.enable = true;
          #              };
          #            };
          #          };
          html.enable = true;
          java.enable = true;
          kotlin.enable = true;
          markdown = {
            enable = true;
            #            extensions.render-markdown-nvim.enable = true; # Supported at the last version in dev
          };
          nix.enable = true;
          php.enable = true;
          python.enable = true;
          #          ruby.enable = true; # Supported at the last version in dev
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
          #          wgsl.enable = true; # Supported at the last version in dev
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
          };
        };

        tabline = {
          nvimBufferline.enable = true;
        };

        treesitter.context.enable = true;

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
          #          yanky-nvim.enable = false; # Supported at the last version in dev
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
          obsidian.enable = false; # FIXME: neovim fails to build if obsidian is enabled
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

        #        assistant = {
        #          chatgpt.enable = false;
        #          copilot = {
        #            enable = false;
        #            cmp.enable = true;
        #          };
        #        };

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
    # Source : https://www.lazyvim.org/
    modules.home.apps.kitty.enable = lib.mkDefault true;
    modules.home.shell.git.enable = lib.mkDefault true;
  };
}
