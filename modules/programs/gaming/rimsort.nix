{ self, inputs, config, ... }: {

  flake.homeModules.gaming = { pkgs, lib, config, osConfig, ... }: {

    options.programs.rimsort.enable = lib.mkEnableOption "rimsort";
    config.programs.rimsort.enable = lib.mkDefault false;

    config.home.packages = lib.mkIf (config.programs.rimsort.enable == true) [ pkgs.rimsort ];


  };


}
