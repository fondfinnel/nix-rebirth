{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, config, ... }: {

    programs.tmux = {
      enable = lib.mkDefault false;
    };

    programs.sesh = {
      enable = lib.mkDefault config.programs.tmux.enable;
    };

  };


}
