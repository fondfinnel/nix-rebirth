{ self, inputs, config, pkgs, ... }: {

  flake.homeModules.hyprland = { lib, self', pkgs, config, osConfig, ... }: let
    hyprenable = osConfig.headless-check;
    hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  in {

    services.hypridle = {
      enable = hyprenable;
    };

    wayland.windowManager.hyprland = let

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

      enable = hyprenable;

      # systemd service always in use
      systemd.enable = hyprenable;
      systemd.variables = [ "--all" ];

      configType = "hyprlang";

      settings = {

        general = {
          gaps_in = 2;
          gaps_out = 6;
          border_size = 1;
          # col needs to be defined this way for ... some reason? hyprland doesn't pick up on including it in squigglies
          "col.active_border" = "rgba(${colors.borderfull})"; # rgba(${colors.bordertrans}) 90deg";
          "col.inactive_border" = "rgba(${colors.border}1a)";      
          layout = "dwindle";
          allow_tearing = false;
        };

        ecosystem.no_update_news = true;

        xwayland.force_zero_scaling = true;
        input = {
          kb_layout = "us";
          follow_mouse = "1";
          touchpad = {
            natural_scroll = "no";
            disable_while_typing = "true";
          };
          sensitivity = "0";
        };

        decoration = {
          rounding = 15;
          rounding_power = 2;
          shadow = { 
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true ;
            size = 1;
            passes = 4;
            special = true;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
          # bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [ 
            "windows,1,0.5,default,gnomed"
            "windowsIn,1,0.5,default,gnomed"
            "windowsMove,1,0.5,default,slide"
            "border,1,3,default"
            "borderangle,1,8,default"
            "fade,1,3,default"
            "workspaces,1,1,default,slide"
            "specialWorkspaceIn,1,2,default,fade"
            "specialWorkspaceOut,1,2,default,fade"
          ];
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
          # no_gaps_when_only = 0;
          special_scale_factor = 0.9;
        };

        windowrule = [
          "match:initial_class ^(steam_app_*)$, tag game"
          "float on, match:class ^(org.kde.keditfiletype)" # kde file type picker
          "float on, match:title ^(Friends List)" # steam friends list
          "float on, match:title ^(Unlock Database - KeePassXC)" # keepass database prompt
          "float on, match:title ^(KeePassXC - Passkey credentials)" # keepass passkey prompt
          "float on, no_anim on, match:class ^(rofi)"
          "workspace special:discord, no_initial_focus on, match:class ^(vesktop)"
          "no_anim on, match:class ^(bemenu)"
          "workspace special:hidden, match:title (Wine System Tray)"
          "no_initial_focus on, match:title Wine System Tray), match:title ^(Picture-in-Picture)"
          "suppress_event activateFocus, match:title (Wine System Tray)"
          "idle_inhibit fullscreen, match:class ^(*)$, match:title ^(*)$"
          "idle_inhibit fullscreen, match:fullscreen 1"
          "match:tag game, fullscreen on"
          "match:modal true, float on"
        ];

        layerrule = [
          "match:namespace waybar, blur on, ignore_alpha 0"
          "match:namespace noctalia-background.*$, blur on, ignore_alpha 0.5, blur_popups on"
          "match:namespace noctalia-notifications.*$, blur on, ignore_alpha 0.5"
          "match:namespace notifications, blur on, ignore_alpha 0"
        ];

        bind = let
          mainMod = "SUPER";
          myTerm = "kitty";
        in [
          # Management
          "${mainMod} SHIFT, Q, killactive" # close active window
          "${mainMod} SHIFT ALT CTRL, Q, exit" # exit session (hyprland)
          ## Toggle status
          "${mainMod}, F, togglefloating" # toggle floating active window
          "${mainMod}, P, pseudo" # pseudotiling, keep floating size in tiled sections
          "${mainMod}, M, fullscreen, 1" # maximize active app
          "${mainMod}, N, togglesplit" # change split
          "${mainMod} SHIFT, M, fullscreen" # fullscreen active window
          ## Move window focus with vim keys
          "${mainMod}, h, movefocus, l" # left
          "${mainMod}, l, movefocus, r" # right
          "${mainMod}, k, movefocus, u" # up
          "${mainMod}, j, movefocus, d" # down
          ## Move windows 
          "${mainMod} SHIFT, h, movewindow, l" # left
          "${mainMod} SHIFT, l, movewindow, r" # right
          "${mainMod} SHIFT, k, movewindow, u" # up
          "${mainMod} SHIFT, j, movewindow, d" # down
          # Workspaces
          ## Move to workspace
          "${mainMod}, 1, focusworkspaceoncurrentmonitor, 1"
          "${mainMod}, 2, focusworkspaceoncurrentmonitor, 2"
          "${mainMod}, 3, focusworkspaceoncurrentmonitor, 3"
          "${mainMod}, 4, focusworkspaceoncurrentmonitor, 4"
          "${mainMod}, 5, focusworkspaceoncurrentmonitor, 5"
          "${mainMod}, 6, focusworkspaceoncurrentmonitor, 6"
          "${mainMod}, 7, focusworkspaceoncurrentmonitor, 7"
          "${mainMod}, 8, focusworkspaceoncurrentmonitor, 8"
          "${mainMod}, 9, focusworkspaceoncurrentmonitor, 9"
          "${mainMod}, 0, focusworkspaceoncurrentmonitor, 10"
          ## Open scratchpads
          "${mainMod}, S, togglespecialworkspace, magic"
          "${mainMod}, A, togglespecialworkspace, note"
          "${mainMod}, D, togglespecialworkspace, discord"
          ## Move window to workspace
          "${mainMod} SHIFT, 1, movetoworkspacesilent, 1"
          "${mainMod} SHIFT, 2, movetoworkspacesilent, 2"
          "${mainMod} SHIFT, 3, movetoworkspacesilent, 3"
          "${mainMod} SHIFT, 4, movetoworkspacesilent, 4"
          "${mainMod} SHIFT, 5, movetoworkspacesilent, 5"
          "${mainMod} SHIFT, 6, movetoworkspacesilent, 6"
          "${mainMod} SHIFT, 7, movetoworkspacesilent, 7"
          "${mainMod} SHIFT, 8, movetoworkspacesilent, 8"
          "${mainMod} SHIFT, 9, movetoworkspacesilent, 9"
          "${mainMod} SHIFT, 0, movetoworkspacesilent, 10"
          ## Move to scratchpads
          "${mainMod} SHIFT, S, movetoworkspace, special:magic"
          "${mainMod} SHIFT, A, movetoworkspace, special:note"
          "${mainMod} SHIFT, D, movetoworkspace, special:discord"
          # Application shortcuts
          "${mainMod}, return, exec, ${myTerm}" # open terminal
          # disabled due to fuzzel no longer playing ball for some reason
          #"${mainMod}, R, exec, fuzzel -b ${colors.background}ee -t ${colors.text}ff -C ${colors.border}ff -s ${colors.border}ff -S ${colors.black}ff -w 50 -R"
          #"${mainMod}, R, exec, bemenu-run -i -c -l 10 -W 0.15 -B 1 -p run --single-instance"
          #"${mainMod}, R, exec, anyrun"
          "${mainMod}, R, exec, ${pkgs.noctalia-shell}/bin/noctalia-shell ipc call launcher toggle"
          # "${mainMod}, R, exec, rofi -show drun"
          "${mainMod}, T, exec, rofi -show window"
          ## media playback
          ",XF86AudioPlay, exec, mpc toggle"
          ",XF86AudioNext, exec, mpc next"
          ",XF86AudioPrev, exec, mpc prev"
          # Volume, if desktop mpd else sink volume
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];
        binde = let
          mainMod = "SUPER";
          myTerm = "kitty";
        in [ # repeat on hold
          ## Resize windows
          "${mainMod} CTRL, h, resizeactive, -40 0"
          "${mainMod} CTRL, l, resizeactive, 40 0"
          "${mainMod} CTRL, k, resizeactive, 0 -40"
          "${mainMod} CTRL, j, resizeactive, 0 40"
        ];
        # Moues bindings
        bindm = let
          mainMod = "SUPER";
          myTerm = "kitty";
        in [
          "${mainMod}, mouse:272, movewindow"
          "${mainMod}, mouse:273, resizewindow"
        ];
      };
    };

  };

}
