{ self, inputs, config, ... }: {

  flake.homeModules.wlr-which-key = { lib, config, pkgs, osConfig, ... }: {

    programs.wlr-which-key = {
      enable = lib.mkDefault osConfig.headless-check;

      settings = with config.lib.stylix.colors.withHashtag; {
        font = "${config.stylix.fonts.monospace.name} 10";
        corner_r = lib.mkDefault 0;
        padding = lib.mkDefault 10;
        background = base00;
        color = base05;
        border = base0D;

        menu = [
          { key = "f" ; desc = "firefox"; cmd = "firefox"; }
          { key = "F" ; desc = "firefox (private)"; cmd = "firefox --private-window"; }
          { key = "e" ; desc = "emacs"; cmd = "${pkgs.emacs}/bin/emacsclient -c"; }
          { key = "p" ; desc = "darktable"; cmd = "${pkgs.darktable}/bin/darktable"; }
        ];

      };

    };

    };


  }
