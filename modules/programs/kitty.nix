{ self, inputs, ... }: {

  # TODO Better theming options

  flake.homeModules.kitty = { lib, config, osConfig, pkgs, ... }: {

    programs.kitty = let
      def = lib.mkDefault;
      var = config.home.sessionVariables;
    in {

      font = def { # fonts
        package = pkgs.nerd-fonts.mononoki; # where the font is from
        name = "Mononoki Nerd Font"; # specific font
        # below DOES NOT BUILD with if statement, as networking.hostName does not get parsed by home-manager, and this is a module within home-manager. Unaware of how to pass this along yet.
        size = 9; 
      };
      
      themeFile = def "default"; # theme 
      # other good alts:ranger
      # PaperColor Dark
      # Cyberpunk & Cyberpunk Neon, CP2077 themes
      # Dark Pastel
      # Kaolin Dark
      # run "kitty +kitten themes" for more
      
      keybindings = def {
        "ctrl+shift+t" = "new_tab_with_cwd";
        "ctrl+shift+k" = "next_tab";
        "ctrl+shift+j" = "previous_tab";
      };
      
      settings = def { 
        editor = var.EDITOR;
        enable_audio_bell = false;
        background_opacity = "0.9";
        confirm_os_window_close = 0;
        notify_on_cmd_finish = "invisible";
        tab_bar_edge = "bottom";
        tab_bar_style = "slant";
        tab_bar_margin_height = "0.0 0.0";
        disable_ligatures = "never";
      };
    };
    
    home.shellAliases = {
      clip = "kitten clipboard";
      notify = "kitten notify";
    };

  };

}
