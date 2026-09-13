{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, config, osConfig, ... }:  let
    check = osConfig.headless-check;
  in {

    programs.obsidian = {
      enable = lib.mkDefault check;
    };

  };


}
