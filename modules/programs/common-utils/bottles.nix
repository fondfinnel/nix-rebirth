{ self, inputs, config, ... }:  {

  flake.homeModules.common-utils = { lib, pkgs, config, osConfig, ... }: let
    check = osConfig.headless-check;
  in{

    options.programs.bottles.enable = lib.mkOption {
      type = lib.types.bool;
      default = check;
    };

    config.home.packages = lib.mkIf config.programs.bottles.enable [
      (pkgs.bottles.override { removeWarningPopup = true; })
    ];


    config.home.preserve.directories = lib.mkIf config.programs.bottles.enable [ ".local/share/bottles" ];

  };


}
