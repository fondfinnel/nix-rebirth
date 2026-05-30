{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.dolphin.enable = lib.mkEnableOption "dolphin";
    config.programs.dolphin.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.dolphin.enable [ pkgs.kdePackages.dolphin ];

  };


}
