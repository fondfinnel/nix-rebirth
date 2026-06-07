{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.nixosModules.common-utils = { lib, ... }: {
    programs.appimage.enable = lib.mkDefault check;
  };

}
