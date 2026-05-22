{ self, inputs, ... }: {

  # TODO Clean up theme options
  flake.homeModules.waybar = { lib, config, osConfig, pkgs, ... }: let
    cfg = config.myOpt.hyprland;

    myFont.font = "Mononoki Nerd Font Mono";
    myFont.size = "10";
    myFont.package = pkgs.nerd-fonts.mononoki;

    colors = { # RGB values, no alpha
      border = "b0ac99"; #b0ac99
      borderfull = "${colors.border}ff";
      bordertrans = "${colors.border}66";
      bordertransrgb = "rgba(176, 172, 153, 0.4)";
      text = "1e1e27"; #1e1e27
      background = "1f1f28"; #1f1f28
      backgroundfull = "${colors.background}ff";
      backgroundtrans = "${colors.background}66";
      backgroundtransrgb = "rgba(31, 31, 40, 0.7)";
      backgroundrgb = "rgba(31, 31, 40, 1)";
      black = "0000000"; #000000
    };
  in {

    programs.waybar = {
      systemd.enable = config.programs.waybar.enable;

      # Style stolen from https://github.com/HeinzDev/Hyprland-dotfiles?tab=readme-ov-file
      style = let
        margin = if cfg.compact then "0px" else "5px";
        anim = if cfg.fancy then "steps(12)" else "steps(3)";
        back = if cfg.fancy then colors.backgroundtransrgb else colors.backgroundrgb;
      in /*css*/ ''
      * {
       font-family: "${myFont.font}";
       font-size: 10pt;
       font-weight: bold;
       border-radius: 0px;
       transition-property: background-color;
       transition-duration: 0.2s;
       padding: 0;
       margin: 0;
      }
      @keyframes blink_red {
       to {
         background-color: rgb(242, 143, 173);
         color: rgb(26, 24, 38);
       }
      }
      .warning, .critical, .urgent {
       animation-name: blink_red;
       animation-duration: 1s;
       animation-timing-function: ${anim};
       animation-iteration-count: infinite;
       animation-direction: alternate;
      }
      window#waybar {
       background-color: transparent;
      }
      window > box {
       margin-left: ${margin};
       margin-right: ${margin};
       margin-top: ${margin};
       background-color: ${back};
       border-radius: ${margin}; 
       border: 1px solid #${colors.border};
      }
      #workspaces {
             padding-left: 0px;
             padding-right: 0px;
             border-radius: 5px;
           }
      #workspaces button {
             padding-top: 0px;
             padding-bottom: 0px;
             padding-left: 2px;
             padding-right: 2px;
           }

      #workspaces button.visibile {
             background-color: #${colors.border};
             color: rgb(26, 24, 38);
           }
      #workspaces button.active {
             background-color: #${colors.border};
             color: rgb(26, 24, 38);
           }
      #workspaces button.urgent {
             color: rgb(26, 24, 38);
           }
      #workspaces button:hover {
             background-color: rgb(248, 189, 150);
             color: rgb(26, 24, 38);
           }
           tooltip {
             background: rgb(48, 45, 65);
           }
           tooltip label {
             color: rgb(217, 224, 238);
           }
      #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
             padding-left: 2px;
             padding-right: 2px;
           }
           /* #mode { */
           /* 	margin-left: 10px; */
           /* 	background-color: rgb(248, 189, 150); */
           /*     color: rgb(26, 24, 38); */
           /* } */
      #memory {
             color: rgb(181, 232, 224);
           }
      #cpu {
             color: rgb(245, 194, 231);
           }
      #clock {
             color: #${colors.background};
             background-color: #${colors.border};
             border-radius: 5px;
           }
      #custom-wall {
             color: #${colors.border};
        }
      #temperature {
             color: rgb(150, 205, 251);
           }
      #backlight {
             color: rgb(248, 189, 150);
           }
      #pulseaudio {
             color: rgb(245, 224, 220);
           }
      #network {
             color: #ABE9B3;
           }
      #network.disconnected {
             color: rgb(255, 255, 255);
           }
      #tray {
             padding-right: 8px;
             padding-left: 10px;
           }
    '';

      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        # Layout of the modules in the bar
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/waybar-mpris" ];
        modules-right = [ "keyboard-state" "group/system" ]; # renders group with all the modules desired, mostly hidden

        # Modules settings
        "tray" = {
          icon-size = 14;
          spacing = 8;
        };
        "mpd" = {
          on-click = "mpc toggle";
          format = "{stateIcon} {artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
          max-length = 60;
          state-icons = {
            paused = "";
            playing = "";
          };
        };

        # group several modules together for less clutter
        "group/system" = {
          orientation = "horizontal";
          drawer = {
            trasition-duration = 100;
            transition-left-to-right = false;
          };
          modules = [
            "clock"
            "tray"
            "pulseaudio"
          ] ++ lib.optionals (osConfig.networking.hostName == "NateT480") [
            "battery"
          ];
        };

        "custom/waybar-mpris" = let wm = "${pkgs.waybar-mpris}/bin/waybar-mpris"; in { # Media playback status
          return-type = "json";
          exec = "${wm} --position --autofocus --interpolate --order ARTIST:TITLE:POSITION";
          on-click = "${wm} --send toggle";
          on-click-right = "${wm} --send player-next";
          escape = true;
        };

        "pulseaudio" = {
          format = "{volume}%";
          format-bluetooth = "{volume}% <U+F294>";
          on-click = "kitty pulsemixer";
        };

        "clock" = {
          format = "{:%I:%M%p}";
          tooltip-format = "{:%Y-%m-%d}\n{calendar}";
          on-click = "makoctl restore";
        };

        "battery" = {
          format = "{icon}  {capacity}%";
          format-icons = ["" "" "" "" ""]; 
        };

        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = true;
          move-to-monitor = true;
        }; 
      };        
    };

  };

}
