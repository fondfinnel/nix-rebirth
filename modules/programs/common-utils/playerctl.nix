{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, osConfig, ... }: {

    services.playerctld.enable = lib.mkDefault osConfig.headless-check;

  };


}
