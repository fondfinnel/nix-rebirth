{ self, inputs, config, ... }: let
  check = config.headless-check;  
in {

  flake.homeModules.common-utils = { pkgs, ... }: {

    programs.mpv = {
      enable = check;

      config = {
        #vo = "opengl-hq:interpolation";
        video-sync = "display-resample";
        osd-bar = "no";
        border = "no";
        keep-open = "yes";
      };

      scripts = with pkgs.mpvScripts; [
        mpris
        uosc
        autodeint
        dynamic-crop
        visualizer
        videoclip
        thumbfast
        quack
        mpv-cheatsheet-ng
      ];

      scriptOpts = {

        uosc = { # theme changes
          timeline_size = 20;
          controls_size = 24;
          volume_size = 20;
          controls_margin = 4;
          top_bar = "never";
          menu_item_height = 24;
          menu_min_width = 200;
          menu_padding = 2;
          flash_duration = 400;
          proximity_in = 30;
          proximity_out = 60;
          animation_duration = 50;
        };

        thumbfast.max_height = 120; # small thumbnails

        videoclip = {
          format = "vp9";
          # video_height = 1080;
          # video_qualty = 28;
          litterbox_expire = "24h";
        };

        quack.ducksecs = 0.5;

      };

      # a couple custom binds, mostly hiding native osv for uosc
      bindings = let
        prevChap = "add chapter -1";
        nextChap = "add chapter 1";
        volUp = "no-osd add volume  5; script-binding uosc/flash-volume";
        volDown = "no-osd add volume -5; script-binding uosc/flash-volume";
        seekFor = "seek  5; script-binding uosc/flash-timeline";
        seekBack = "seek -5; script-binding uosc/flash-timeline";
        seekForP = "seek  30; script-binding uosc/flash-timeline";
        seekBackP = "seek -30; script-binding uosc/flash-timeline";
      in {
        "ALT+LEFT" = prevChap; # next chapter 
        "ALT+H" = prevChap; # next chapter with vim
        "ALT+RIGHT" = nextChap; # prev chapter
        "ALT+L" = nextChap; # prev chapter with vim

        "space" = "cycle pause; script-binding uosc/flash-pause-indicator";
        "m" = "no-osd cycle mute; script-binding uosc/flash-volume";

        "up" = volUp;
        "down" = volDown;
        "WHEEL_UP" = volUp;
        "WHEEL_DOWN" = volDown;

        "left" = seekBack;
        "right" = seekFor;
        "SHIFT+left" = seekBackP;
        "SHIFT+right" = seekForP;
      };
    };

    xdg.mimeApps.defaultApplications = let x = "mpv.desktop"; in {
      "video/mp4" = [ x ];
      "video/quicktime" = [ x ];
      "video/webm" = [ x ];
      "video/x-matroska" = [ x ];
      "video/vnd.avi" = [ x ];
      "audio/flac" = [ x ];
      "audio/mp4" = [ x ];
      "audio/mpeg" = [ x ];
    };

  };


}
