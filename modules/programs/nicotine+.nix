{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check;
  in {

    options.programs.nicotine-plus.enable = lib.mkEnableOption "nicotine-plus";
    config.programs.nicotine-plus.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.nicotine-plus.enable [ pkgs.nicotine-plus ];

  };


}
