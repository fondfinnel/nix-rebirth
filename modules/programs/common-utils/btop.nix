{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, ... }: {

    programs.btop = {

      enable = true;

      settings = {
        # theme_background = false;
        rounded_corners = true;
        # color_theme = lib.mkDefault "monokai";
        proc_sorting = "cpu lazy";
        net_auto = true;
        net_sync = true;
        show_battery = true;
        # cpu_single_graph = true;
        vim_keys = true;
        update_ms = 1000;
        graph_symbol_cpu = "block";
      };

    };

    home.shellAliases.top = "btop";

  };


}
