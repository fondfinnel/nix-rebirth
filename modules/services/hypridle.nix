{ self, inputs, config, ... }: let
  hyprenable = config.headless-check;
  highperf = config.high-performance;
in {

  flake.homeModules.hypridle = { ... }: {

    services.hypridle = {

      enable = hyprenable;

      settings = { # writes into ~/.config/hypr/hypridle.conf        
        general.after_sleep_cmd = "hyprctl dispatch dpms on";
        general.ignore_dbus_inhibit = false;
        general.lock_cmd = "noctalia-shell ipc call lockScreen lock";
        listener = [

          { # lockscreen after ten mins, 1hr if desktop
            timeout = if highperf then 3600 else 600;
            on-timeout = "noctalia-shell ipc call lockScreen lock";
          }

          { # turn off displays after 2 minutes
            timeout = 120;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }

        ];
      };
    };
  };
}
