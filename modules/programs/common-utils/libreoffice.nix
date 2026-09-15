{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check;
  in {

    options.programs.libreoffice.enable = lib.mkEnableOption "libreoffice";
    config.programs.libreoffice.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.libreoffice.enable [ pkgs.libreoffice ];

  };


}
