{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, osConfig, ... }: let
    check = osConfig.headless-check;
  in {

    # this is not needed on servers
    home.packages = with pkgs; lib.mkIf check [
      android-file-transfer
      android-tools
      libmtp
    ];

  };


}
