{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.zellij = {
      enable = lib.mkDefault true;
      settings = lib.mkDefault {
        show_startup_tips = false;
      };
    };

    programs.fish.shellInitLast = ''
    if status is-interactive
      if type -q zellij
          # Update the zellij tab name with the current process name or pwd.
          function zellij_tab_name_update_pre --on-event fish_preexec
              if set -q ZELLIJ
                  set -l cmd_line (string split " " -- $argv)
                  set -l process_name $cmd_line[1]
                  if test -n "$process_name" -a "$process_name" != "z"
                      command nohup zellij action rename-tab $process_name >/dev/null 2>&1
                  end
              end
          end

          function zellij_tab_name_update_post --on-event fish_postexec
              if set -q ZELLIJ
                  set -l cmd_line (string split " " -- $argv)
                  set -l process_name $cmd_line[1]
                  if test "$process_name" = "z"
                      command nohup zellij action rename-tab (prompt_pwd) >/dev/null 2>&1
                  end
              end
          end
      end
    end
  '';

  };


}
