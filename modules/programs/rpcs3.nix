{ self, inputs, config, ... }: let
  check = config.headless-check == config.high-performance;
in {

  flake.homeModules.gaming = { pkgs, lib, config, ... }: {

    options.programs.rpcs3.enable = lib.mkEnableOption "rpcs3";
    config.programs.rpcs3.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.rpcs3.enable [ pkgs.rpcs3 ];

  };


}
