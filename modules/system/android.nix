{ self, inputs, config, ... }: let
  check = config.headless-check;
in{

  flake.homeModules.common-utils = { pkgs, lib, ... }: {

    # this is not needed on servers
    home.packages = with pkgs; lib.mkIf check [
      android-file-transfer
      android-tools
      libmtp
    ];

  };


}
