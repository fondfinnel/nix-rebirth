{ self, inputs, config, ... }: {

  flake.homeModules.gaming = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check && osConfig.high-performance;
  in {

    options.programs.rpcs3.enable = lib.mkEnableOption "rpcs3";

    # building fails, disabling for time being
    config.programs.rpcs3.enable = lib.mkDefault false;

    config.home.packages = lib.mkIf config.programs.rpcs3.enable [ pkgs.rpcs3 ];

  };


}
