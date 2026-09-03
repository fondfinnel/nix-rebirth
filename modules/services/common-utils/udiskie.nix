{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.nixosModules.common-utils = { lib, ... }: { services.udisks2.enable = lib.mkDefault check; };

  flake.homeModules.common-utils = { pkgs, lib, osConfig, config, ... }: {

    services.udiskie.enable = osConfig.services.udisks2.enable;
    services.udiskie.tray = "never";

    home.activation.symUdiskie = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
     run ln -sfn /run/media/${config.home.username} "${config.home.homeDirectory}/media"
    '';

    
  };

}
