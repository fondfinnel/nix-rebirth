{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {


    programs.helix = {
      enable = lib.mkDefault true;

      # package = pkgs.evil-helix;

      extraPackages = with pkgs; lib.mkDefault [
        # marksman # markdown
        nil # nix
        # python312Packages.python-lsp-server # python
        markdown-oxide # markdown lsp for notes
        # ruff # python
        # black # python
        fish-lsp
        clang # c++
      ];

      settings = { # writes into ~/.config/helix/config.toml

        theme = lib.mkDefault "kanagawa";

        editor = {

          end-of-line-diagnostics = "hint";

          inline-diagnostics = {
            cursor-line = "error";
            other-lines = "disable";
          };

          auto-save.focus-lost = true;
          line-number = "relative";
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          statusline = {
            mode.normal = "N";
            mode.insert = "I";
            mode.select = "S";
            left = [ "mode" "spinner" "read-only-indicator" "file-modification-indicator" ];
            center = [ "file-name" ];
            right = [ "diagnostics" "selections" "register" "separator" "file-type" "version-control" "spacer" "position-percentage" ];
          };

          indent-guides.render = true;
          indent-guides.skip-levels = 1;
          color-modes = true;
          cursorline = true;

          lsp = {
            auto-signature-help = false;
            display-messages = true;
          };

        };

        keys.normal = {
          "X" = "extend_line_above"; # Same functionaity as x, however it's for up instead of down
          "space"."s" = ":toggle soft-wrap.enable";

          "backspace"."g" = ":sh zellij run -fc --height 80%% --width 80%% -x 10%% -y 10%% -- jjui"; # jjui popup
          "backspace"."j" = ":sh zellij run -fc --height 80%% --width 80%% -x 10%% -y 10%% -- jjui"; # jjui popup
          "backspace"."t" = ":sh zellij run -fc --height 80%% --width 80%% -x 10%% -y 10%% -- fish";

          # while in zellij, helix will use yazi to pick files
          "C-y"."y" = ":sh zellij run -fc -x 10%% -y 10%% --width 80%% --height 80%% -- bash ~/.config/helix/yazi-picker.sh open"; 
          "C-y"."v" = ":sh zellij run -fc -x 10%% -y 10%% --width 80%% --height 80%% -- bash ~/.config/helix/yazi-picker.sh vsplit"; 
          "C-y"."h" = ":sh zellij run -fc -x 10%% -y 10%% --width 80%% --height 80%% -- bash ~/.config/helix/yazi-picker.sh hsplit"; 
        };

      };

      languages.markdown.soft-wrap.enable = true;

    };

    programs.zellij.enable = lib.mkDefault config.programs.helix.enable;
    home.shellAliases.hx =
      "zellij --layout ${(pkgs.writeText "helix.kdl"
        ''
          layout {
            pane command="hx" close_on_exit=true name="helix" borderless=true
          }
       '')}
      ";

    # script for yazi as file picker, see https://yazi-rs.github.io/docs/tips/#helix-with-zellij
    xdg.configFile."helix/yazi-picker.sh" = {
      enable = true;
      text = ''
      #!/usr/bin/env bash
      paths=$(yazi --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)

      if [[ -n "$paths" ]]; then
      	zellij action toggle-floating-panes
      	zellij action write 27 # send <Escape> key
      	zellij action write-chars ":$1 $paths"
      	zellij action write 13 # send <Enter> key
      else
      	zellij action toggle-floating-panes
      fi
     '';
    };

  };


}
