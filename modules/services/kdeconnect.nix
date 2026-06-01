{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flakes.nixosModules.common-utils = { config, lib, ... }: {

    services.kdeconnect.enable = lib.mkDefault check;

  };

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    services.kdeconnect = {
      enable = lib.mkDefault osConfig.services.kdeconnect.enable;
      indicator = config.services.kdeconnect.enable;
    };

  };


}
