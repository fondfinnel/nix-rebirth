{ self, inputs, config, ... }: {

  # very old neovim config over nixvim
  # not using at the moment, would need flake added

  flake.homeModules.neovim = { lib, config, pkgs, ... }: {
    
    programs.nixvim = {
	    enable = true;
      files = {
	      "ftplugin/nix.lua" = {
	        opts = {
	          expandtab = true; # Set tab to 2
		        shiftwidth = 2;
            tabstop = 2;
	        };
	      };
	    };
      extraConfigLuaPost = "vim.opt.conceallevel = 2";

      # Ricing
      # try cyberdream if you can get transp
	    colorschemes = lib.mkDefault {
	      vscode.enable = true;
        # kanagawa.enable = true;
	    };

      # Plugins
	    
	    plugins.lualine = { # status bar
	      enable = true;
	      settings.extensions = [
		      "fzf"
	      ];
	      settings.options.globalstatus = true;
	    };
	    plugins.bufferline = {  # tab bar
	      enable = true;
	      settings.options.separator_style = "slant";
	    };
	    plugins.telescope = { # file search and whatnot
	      enable = true;
	      extensions.fzf-native = { enable = true; };
	    }; 
	    plugins.oil.enable = true;
	    plugins.treesitter.enable = true; # syntax highlights
	    plugins.transparent.enable = true;
	    plugins.neoscroll.enable = true; # Smooth scrolling, might not work
	    plugins.nvim-autopairs.enable = true; # pair quotes
	    plugins.colorizer.enable = true;
	    plugins.twilight.enable = true; # Toggle a focused mode
	    plugins.zen-mode.enable = true; # Toggle a focused mode
      plugins.indent-blankline.enable = true; # Draw lines for indents
	    plugins.lsp = { # provide libraries for syntax highlighting
	      enable = true;
	      servers = {
          ts_ls.enable = true;
          lua_ls = {
            enable = true;
            settings.telemetry.enable = false;
          };
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
	      };
	    };
	    plugins.lspsaga.enable = true;
	    plugins.cmp = {
	      enable = true;
	      autoEnableSources = true;
        settings = { # from https://nix-community.github.io/nixvim/plugins/cmp/settings/index.html
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
              })
            '';
          };
          snippet = {
            expand = "function(args) require('luansnip').lsp_expand(args.body) end";
          }; 
        };
	    };
	    plugins.neo-tree = {
	      enable = true;
	      enableGitStatus = true;
	      enableModifiedMarkers = true;
	    };
	    plugins.luasnip.enable = true;
      # obsidian = {
      #   enable = true;
      #   settings = {
      #     completion = {
      #       min_chars = 2;
      #       nvim_cmp = true;
      #     };
      #     new_notes_location = "notes_subdir";
      #     workspaces = [
      #       {
      #         name = "Main";
      #         path = "~/Obsidian - n0ll";
      #       }
      #     ];
      #   };
      # };
      plugins.web-devicons.enable = true;
	    
      # Keyboard shortcuts
	    globals.mapleader = " ";
	    keymaps = [
	      {
	        key = "<C-e>";
	        action = "<cmd>Neotree toggle<CR>";
	      }
	      {
	        key = "<C-o>";
	        action = "<cmd>Telescope find_files<CR>";
	      }
	      {
	        key = "<C-p>";
	        action = "<cmd>Telescope<CR>";
	      }
	    ];
	  };

	  programs.bash.shellAliases.vim = "nvim";
    
  };


}
