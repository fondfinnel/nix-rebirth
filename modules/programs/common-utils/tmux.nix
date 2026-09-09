{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, config, ... }: let
    check = config.programs.tmux.enable;
  in {

    programs.tmux = {
      enable = lib.mkDefault true;
    };

    programs.sesh = {
      enable = lib.mkDefault check;
    };

    programs.fzf.tmux.enableShellIntegration = lib.mkDefault check;

  };


}
