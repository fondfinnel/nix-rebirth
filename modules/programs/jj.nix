{ self, inputs, config, ... }: {

  flake.homeModules.development = { pkgs, lib, config, ... }: let d = lib.mkDefault; in {
    
    programs.jujutsu = {
      enable = d true;

      settings = {
        "${config.home.username}" = {
          name = d config.home.username;
          email = d "";
        };

        ui.default-command = ["log"];
        # use set PAGER, if not set use less
        ui.pager = ["sh" "-c" "exec \$\{PAGER:-less -FRX}"];
        ui.graph.style = "square";

        aliases = {
          a = ["abandon"];
          d = ["desc"];
          u = ["undo"];
          n = ["new"];
          c = ["commit"];

          fetch = ["git" "fetch"];
          push = ["git" "push"];
          pull = ["git" "pull"];
          clone = ["git" "clone"];
        };

        snapshot.auto-update-stale = true;
        fsmonitor.backend = pkgs.watchman;
        watchman.register_snapshot_trigger = true;

        colors = let

          # color for if remote or local
          col.remote = "bright cyan";
          col.local = "bright green";
          col.curr = "bright blue";
          col.err = "bright red";
          col.back = "bright black";

        in {
          normal.change_id = { bold = true; fg = "magenta"; };
          immutable."change_id" = { bold = false; fg = col.remote; };

          node = {
            bold = true;

            elided.fg = "bright black";
            working_copy.fg = "green";
            conflict.fg = col.err;
            immutable.fg = col.remote;
            wip.fg = "yellow";
          };

          timestamp.fg = col.back;

          local_bookmarks.fg = col.local;
          remote_bookmarks.fg = col.remote;

          text.link = { bold = true; fg = "magenta"; };
          text.warning = { bold = true; fg = "red"; };
        };

        templates.log = "builtin_log_oneline";
      };
    };
    programs.bash.shellAliases.j = lib.mkIf config.programs.jujutsu.enable "jj";

    programs.jjui = {
      enable = d config.programs.jujutsu.enable;

      settings = d {
        preview.show_at_start = true;
        ui.ui.tracer.enabled = true;
      };
    };
    programs.bash.shellAliases.jj = lib.mkIf config.programs.jjui.enable "jjui";

  };


}
