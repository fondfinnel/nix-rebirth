{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.nixosModules.common-utils = { config, lib, ... }: {

    programs.kdeconnect.enable = lib.mkDefault check;

  };

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: {

    services.kdeconnect = {
      enable = lib.mkDefault check;
      indicator = config.services.kdeconnect.enable;
    };

  };


}
