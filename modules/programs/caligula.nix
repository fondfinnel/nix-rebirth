{ self, inputs,  ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.caligula.enable = lib.mkEnableOption "caligula";
    config.programs.caligula.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf (config.programs.caligula.enable == true) [ pkgs.caligula ];
    config.home.shellAliases.dd = "caligula";

  };


}
