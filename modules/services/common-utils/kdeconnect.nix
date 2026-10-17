{ self, inputs, config, ... }: {

  flake.nixosModules.common-utils = { config, lib, ... }: let
    check = config.headless-check;
  in { programs.kdeconnect.enable = lib.mkDefault check; };

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: {

    services.kdeconnect = {
      enable = lib.mkDefault osConfig.programs.kdeconnect.enable;
      indicator = lib.mkDefault config.services.kdeconnect.enable;
    };

    home.preserve.directories = [
      ".config/kdeconnect"
    ];

  };


}
