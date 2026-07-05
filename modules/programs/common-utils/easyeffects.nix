{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { lib, osConfig, config, ... }: {

    services.easyeffects = {
      enable = lib.mkDefault osConfig.headless-check;
    };

  };


}
