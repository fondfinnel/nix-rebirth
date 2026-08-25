{ self, inputs, config, ... }: {

  flake.homeModules.ironbar = { inputs, lib, config, ... }: {

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
          {
            anchor_to_edges = true;
            position = "top";
            height = 16;

            # left modules
            start = [
              { type = "workspaces"; }
            ];

            center = [
              {
                type = "music";
                format = "{artist} - {title}";
                marquee.enable = true;
                marquee.max_length = 24;
                marquee.scroll_speed = 0.2;
                # icons = {
                # TODO
                # };
              }
            ];

            # right modules
            end = [
              { type = "tray"; }
              {
                type = "network_manager";
              }
              {
                type = "battery";
                show_if = "ls /sys/class/power_supply/ | grep --quiet '^BAT'";
              }
              {
                type = "sys_info";
                format = [
                  "{cpu_percent} "
                  "{memory_percent} "
                ];
                interval.cpu = 1;
              }
              { type = "keyboard"; }
              { type = "clock"; }
            ];

          };

        style = '' 
            * {
            font-family: ${config.stylix.fonts.sansSerif.name}, sans-serif;
            font-size: ${builtins.toString (config.stylix.fonts.sizes.applications + 2)}px;
            border: none;
            border-radius: 0;
            }
        '';
      };

  };


}
