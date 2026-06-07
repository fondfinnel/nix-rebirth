{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.ncdu.enable = lib.mkEnableOption "ncdu";
    config.programs.ncdu.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf config.programs.ncdu.enable [ pkgs.ncdu ];

  };


}
