{ self, inputs, config, ... }: let
  check = config.headless-check;
in{

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.duf.enable = lib.mkEnableOption "duf";
    config.programs.duf.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf (config.programs.duf.enable == true) [ pkgs.duf ];

  };

}
