{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.calc.enable = lib.mkEnableOption "calc";
    config.programs.calc.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf config.programs.calc.enable [ pkgs.calc ];

  };


}
