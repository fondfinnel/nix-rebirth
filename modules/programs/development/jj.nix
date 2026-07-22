{ self, inputs, config, ... }: {

  flake.homeModules.development = { pkgs, lib, config, ... }: let d = lib.mkDefault; in {

    home.packages = lib.mkIf config.programs.jujutsu.enable [ pkgs.watchman ];

    programs.delta.enableJujutsuIntegration = lib.mkDefault config.programs.jujutsu.enable;
    
    programs.jujutsu = {
      enable = d true;

      settings = {
        user = {
          name = d config.home.username;
          email = d "";
        };

        ui.default-command = ["log"];
        ui.color = "always";
        # use set PAGER, if not set use less
        # ui.pager = lib.mkDefault ["sh" "-c" "exec \$\{PAGER:-less -FRX}"];
        ui.streampager = lib.mkDefault "quit-if-one-page";

        # curved, square, ascii, ascii-large
        ui.graph.style = "curved";

        aliases = {
          a = ["abandon"];
          d = ["desc"];
          dd = [ "desc" "-m"];
          u = ["undo"];
          n = ["new"];
          c = ["commit"];

          fetch = ["git" "fetch"];
          push = ["git" "push"];
          pull = ["git" "fetch"];
          clone = ["git" "clone"];
        };

        snapshot.auto-update-stale = true;

        # this is only accepted as the string watchman, can't declare the bin
        fsmonitor.backend = "watchman";
        watchman.register_snapshot_trigger = true;

        #     colors = let

        #       # color for if remote or local
        #       col.remote = "bright cyan";
        #       col.local = "bright green";
        #       col.curr = "bright blue";
        #       col.err = "bright red";
        #       col.back = "bright black";

        #     in {
        #       normal.change_id = { bold = true; fg = "magenta"; };
        #       immutable."change_id" = { bold = false; fg = col.remote; };

        #       node = {
        #         bold = true;

        #         elided.fg = "bright black";
        #         working_copy.fg = "green";
        #         conflict.fg = col.err;
        #         immutable.fg = col.remote;
        #         wip.fg = "yellow";
        #       };

        #       timestamp.fg = col.back;

        #       local_bookmarks.fg = col.local;
        #       remote_bookmarks.fg = col.remote;

        #       text.link = { bold = true; fg = "magenta"; };
        #       text.warning = { bold = true; fg = "red"; };
        #     };

        #     templates.log = "builtin_log_oneline";
      };
    };

    programs.jjui = {
      enable = d config.programs.jujutsu.enable;

      settings = d {
        preview.show_at_start = true;
        ui.ui.tracer.enabled = true;
      };
    };
    home.shellAliases.ju = lib.mkIf config.programs.jjui.enable "jjui";

  };


}
