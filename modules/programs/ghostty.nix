{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.ghostty = {
      enable = lib.mkDefault false;

      settings = lib.mkDefault {

        theme = "Kanagawa Wave";

        background-opacity = 0.9;
        font-family = "Mononoki Nerd Font Mono";
        font-size = 12;

        window-decoration = false;
        confirm-close-surface = false;
        mouse-hide-while-typing = true;
        window-padding-x = 0;
        window-padding-y = 0;
      };
    };

  };


}
