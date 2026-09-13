{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { osConfig, pkgs, lib, config, ... }: let
    check = osConfig.headless-check;
  in {

    options.programs.dolphin.enable = lib.mkEnableOption "dolphin";
    config.programs.dolphin.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.dolphin.enable [ pkgs.kdePackages.dolphin ];

  };


}
