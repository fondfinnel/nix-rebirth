{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.nixosModules.common-utils = { lib, ... }: { services.udisks2.enable = lib.mkDefault check; };

  flake.homeModules.common-utils = { pkgs, lib, osConfig, ... }: {

    services.udiskie.enable = osConfig.services.udisks2.enable;

    # TODO Write script for symlinking the media mount point
  };

}
