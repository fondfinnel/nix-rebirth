{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { lib, ... }: {

    programs.btop = {

      enable = true;

      settings = {
        theme_background = false;
        rounded_corners = true;
        color_theme = lib.mkDefault "monokai";
        proc_sorting = "cpu direct";
        net_auto = true;
        net_sync = true;
        show_battery = true;
        cpu_single_graph = true;
      };

    };

    home.shellAliases.top = "btop";

  };


}
