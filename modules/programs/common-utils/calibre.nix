{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check && osConfig.high-performance;
  in {

    config.programs.calibre.enable = check;
    config.home.packages = lib.mkIf config.programs.calibre.enable [ pkgs.calibre ];

    config.home.preserve.directories = lib.mkIf config.programs.calibre.enable [ ".config/calibre" ];

  };


}
