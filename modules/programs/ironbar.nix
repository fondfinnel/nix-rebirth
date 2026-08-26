{ self, inputs, config, ... }: {

  flake.homeModules.ironbar = { osConfig, inputs, lib, config, ... }: {

    # not in nixpkgs, needs added from flake inputs
    imports = [
      inputs.ironbar.homeManagerModules.default
    ];

    programs.ironbar =
      {
        enable = lib.mkDefault true;
        systemd = lib.mkDefault true;
        # package = inputs.ironbar;

        config = lib.mkDefault
          rec {
            anchor_to_edges = true;
            position = "top";
            height = 14;

            # left modules
            start = [
              {
                type = "workspaces";
                hidden = [
                  "special:discord"
                  "special:magic"
                ];
                all_monitors = true;
              }
              {
                type = "focused";
                show_icon = true;
                show_title = false;
                icon_size = height;
              }
            ];

            center = [
              {
                type = "music";
                format = "{artist} - {title}";
                marquee.enable = true;
                marquee.max_length = 28;
                marquee.scroll_speed = 0.2;
                player_type = if config.services.mpd.enable then "mpd" else "mpris";
                music_dir = config.services.mpd.musicDirectory;
                # icons = {
                # TODO
                # };
              }
            ];

            # right modules
            end = [
              { type = "tray"; icon_size = height; }
              # {
              # type = "network_manager";
              # }
              {
                type = "battery";
                show_if = "ls /sys/class/power_supply/ | grep --quiet '^BAT'";
              }
              { type = "volume"; }
              {
                type = "sys_info";
                format = [
                  "{cpu_percent} "
                  "{memory_percent} "
                ];
                interval.cpu = 1;
              }
              # { type = "keyboard"; }
              { type = "clock"; }
            ];

          };

        style = '' 
            :root {
                --color-dark-primary: ${config.lib.stylix.colors.withHashtag.base00};
                --color-dark-secondary: ${config.lib.stylix.colors.withHashtag.base02};
                --color-white: ${config.lib.stylix.colors.withHashtag.base05};
                --color-active: ${config.lib.stylix.colors.withHashtag.base0D};
                --color-urgent: ${config.lib.stylix.colors.withHashtag.base08};

                --margin-lg: 1em;
                --margin-sm: 0.5em;
            }

            * {
                font-family: ${config.stylix.fonts.monospace.name}, monospace;
                font-size: ${builtins.toString (config.stylix.fonts.sizes.applications + 2)}px;
                border: none;
                border-radius: 0;
            }

            scale > trough {
                background-color: var(--color-dark-secondary);
            }

            scale > trough > highlight {
                background-color: var(--color-active);
                border-style: solid;
                border-color: var(--color-active);
                border-width: 0.2em;
            }

            scale > trough > slider {
                background-color: var(--color-white);
            }

            switch > slider {
                background-color: var(--color-white);
            }

            switch:checked {
                background-color: var(--color-active);
            }

            switch:not(:checked) {
            background-color: var(--color-dark-secondary);
            }

            #bar, popover, popover contents, calendar, popover .view {
                background-color: var(--color-dark-primary);
            }

            box, button, label {
                background-color: #0000;
                color: var(--color-white);
            }

            button {
                padding-left: var(--margin-sm);
                padding-right: var(--margin-sm);
            }

            button:hover, button:active, *:selected {
                background-color: var(--color-dark-secondary);
            }

            #end > * + * {
                margin-left: var(--margin-lg);
            }

            .sysinfo > * + * {
                margin-left: var(--margin-sm);
            }

            .clock {
                font-weight: bold;
            }

            .popup-clock .calendar-clock {
                font-size: 2.0em;
            }

            .popup-clock .calendar .today {
                background-color: var(--color-active);
            }

            .workspaces .item.visible {
                box-shadow: inset 0 -1px var(--color-white);
            }

            .workspaces .item.focused {
                box-shadow: inset 0 -1px var(--color-active);
                background-color: var(--color-dark-secondary);
            }

            .workspaces .item.urgent {
                background-color: var(--color-urgent);
            }
        '';
      };

  };


}
