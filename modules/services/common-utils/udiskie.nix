{ self, inputs, config, ... }: {

  flake.nixosModules.common-utils = { lib, config, ... }: let
    check = config.headless-check;
  in { services.udisks2.enable = lib.mkDefault check; };

  flake.homeModules.common-utils = { pkgs, lib, osConfig, config, ... }: {

    # udiskie needs udisks2, which is only system scope
    services.udiskie.enable = osConfig.services.udisks2.enable;
    services.udiskie.tray = "never";

    home.activation.symUdiskie = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
     run ln -sfn /run/media/${config.home.username} "${config.home.homeDirectory}/media"
    '';

    
  };

}
