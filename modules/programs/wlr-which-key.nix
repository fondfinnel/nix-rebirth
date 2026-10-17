{ self, inputs, config, ... }: {

  flake.homeModules.wlr-which-key = { lib, config, pkgs, ... }: {

    programs.wlr-which-key = {
      enable = lib.mkDefault true;

      settings = with config.lib.stylix.colors.withHashtag; {
        font = "${config.stylix.fonts.monospace.name} 10";
        corner_r = lib.mkDefault 0;
        padding = lib.mkDefault 10;
        background = base00;
        color = base05;
        border = base0D;

        menu = [
          { key = "f" ; desc = "firefox"; cmd = "librewolf"; }
          { key = "e" ; desc = "emacs"; cmd = "${pkgs.emacs}/bin/emacsclient"; }
          { key = "p" ; desc = "darktable"; cmd = "${pkgs.darktable}/bin/darktable"; }
        ];

      };

    };

    };


  }
