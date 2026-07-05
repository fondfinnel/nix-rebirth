{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.nicotine-plus.enable = lib.mkEnableOption "nicotine-plus";
    config.programs.nicotine-plus.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.nicotine-plus.enable [ pkgs.nicotine-plus ];

  };


}
