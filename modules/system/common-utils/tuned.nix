{ self, inputs, config, ... }: {

  flake.nixosModules.common-utils = { lib, config, pkgs, ... }: {

    services.tuned.enable = lib.mkDefault true;

    # can't run tlp with tuned
    services.tlp.enable = lib.mkIf config.services.tuned.enable false;

  };


}
