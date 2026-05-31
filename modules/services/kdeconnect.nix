{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    services.kdeconnect = {
      enable = lib.mkDefault check;
      indicator = config.services.kdeconnect.enable;
    };

  };


}
