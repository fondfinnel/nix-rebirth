{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { lib, config, ... }: {

    programs.obsidian = {
      enable = lib.mkDefault check;
    };

  };


}
