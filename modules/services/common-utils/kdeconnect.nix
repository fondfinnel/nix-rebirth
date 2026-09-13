{ self, inputs, config, ... }: {

  flake.nixosModules.common-utils = { config, lib, ... }: let
    check = config.headless-check;
  in { programs.kdeconnect.enable = lib.mkDefault check; };

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: {

    services.kdeconnect = rec {
      enable = lib.mkDefault osConfig.programs.kdeconnect.enable;
      indicator = lib.mkDefault true;
    };

    home.preserve.directories = [
      ".config/kdeconnect"
    ];

  };


}
