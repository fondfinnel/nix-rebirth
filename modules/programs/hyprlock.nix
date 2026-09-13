{ self, inputs, config, pkgs, ... }: {

  flake.homeModules.hyprlock = { osConfig, ... }: let
    hyprenable = osConfig.headless-check;
  in {

    programs.hyprlock = { # mostly copied from example online
      enable = hyprenable;

      settings = { # writes into ~/.config/hypr/hyprlock.conf
        general.disable_loading_bar = true;
        general.grace = 5;
        general.hide_cursor = true;
        general.no_fade_in = false;
        input-field = [{
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(230, 195, 132)";
          outer_color = "rgb(34, 50, 73)";
          inner_color = "rgb(45, 79, 103)";
          outline_thickness = 5;
          placeholder_text = "<i>Password</i>";
          shadow_passes = 2;
        }];

      };
    };

  };


}
