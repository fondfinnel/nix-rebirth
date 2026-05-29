{ self, inputs, config, lib, ... }: let
  # enable only for devices with high-performance
  highperf = config.high-performance;
in {

  flake.homeModules.picom = { ... }: {	

    services.picom = {
      enable = lib.default highperf;
      # general settings
      backend = "glx";
      vSync = true;
      # Fading
      # fade = true;
      # fadeSteps = [ 0.028 0.03 ];
      # fadeDelta = 1;
      # shadow = false;
      # Opacity / Transparency
      # activeOpacity = 1.0;
      # inactiveOpacity = 1.0;
      # opacityRules = [ 
      #   "95:class_g = 'kitty' && focused" # Focused kitty window has slight transparency 
      #   "95:class_g = 'kitty' && !focused" # Unfocused kitty window has slightly more transparency
      #   "80:class_g = 'rofi'" # Rofi can be transparent too I guess.
      # ];

      # blur settings, can't seem to get working however.    
      settings = {
        glx-no-stencil = true;
        blur-method = "dual_kawase";
        blur-size = 6;
        blur-deviation = 0.84089642;
        blur-strength = 6;
        # blur-background = true;
        # blur-kern = "3x3box";
        # blur-background-exclude = [
        #   "window_type = 'dock'"
        #   "window_type = 'desktop'"
        #   "_GTK_FRAME_EXTENTS@:c"
        # ];
        corner-radius = 2;
      };
    };
  };

}
