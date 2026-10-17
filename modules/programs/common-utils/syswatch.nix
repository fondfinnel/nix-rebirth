{ self, inputs, config, ... }: {


  flake.homeModules.common-utils = { lib, config, pkgs, ... }: {

    options.programs.syswatch.enable = lib.mkEnableOption "syswatch";
    config.programs.syswatch.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf (config.programs.syswatch.enable == true) [ pkgs.syswatch ];

  };


}
