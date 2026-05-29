{ self, inputs, ... }: {

  flake.homeModules.dunst = { lib, ... }: { 
    # Dunst notifications (writes in ~/.config/dunst/dunstrc)
	  services.dunst = {
	    enable = true;
		  settings = {
			  global = lib.mkDefault {
				  # Where notifications spawn
				  monitor = "0";
				  follow = "none";
				  width = 300;
				  height = 150;
				  origin = "top-right";
				  offset = "0x24";
				  scale = 0;
				  # Various appearance settings
				  notification_limit = 2;
				  progress_bar = true;
				  progress_bar_height = 10;
				  progress_bar_frame_width = 1;
				  transparency = 10;
				  separator_height = 2;
				  horizontal_padding = 0;
				  frame_width = 2;
				  frame_color = "#FFFFFF";
				  gap_size = 0;
				  separator_color = "frame";
				  sort = "yes";
				  # Fonts and text alignment
				  font = "terminus";
				  markup = "full";
				  format = "<b>%s</b>\n%b";
				  alignment = "left";
				  vertical_alignment = "center";
				  show_age_threshold = 60; # Length notification shows in seconds
				  mouse_left_click = "close_current";
				  mouse_middle_click = "do_action, close_current";
				  mouse_right_click = "close_all";
				  fullscreen = "show"; # When to show a notification with something fullscreen (options: delay, pushback, show)
			  };
			  urgency_critical = { fullscreen = "show"; };
	    };
	  };
  };

}

