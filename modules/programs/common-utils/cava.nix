{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { lib, ... }: {
    programs.cava = {
      enable = lib.mkDefault check;

      settings = lib.mkDefault {

        general = {
          mode = "normal";
          autosens = 1;
          sensitivity = 150;
          # bars = 100;
          bar_width = 1;
          bar_spacing = 0;
          framerate = 144;            
        };

        output.channels = "mono";
        output.mono_option = "average";
        smoothing.monstercat = 1;

        color = {
          gradient = 1;
          gradient_count = 8;
          gradient_color_1 = "'#59cc33'";
          gradient_color_2 = "'#80cc33'";
          gradient_color_3 = "'#a6cc33'";
          gradient_color_4 = "'#cccc33'";
          gradient_color_5 = "'#cca633'";
          gradient_color_6 = "'#cc8033'";
          gradient_color_7 = "'#cc5933'";
          gradient_color_8 = "'#cc3333'";
        };

      };
    };
  };


}
