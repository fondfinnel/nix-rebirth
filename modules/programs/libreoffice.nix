{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.libreoffice.enable = lib.mkEnableOption "libreoffice";
    config.programs.libreoffice.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.libreoffice.enable [ pkgs.libreoffice ];

  };


}
