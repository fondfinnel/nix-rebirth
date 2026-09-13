{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check;
  in {

    config.programs.thunderbird.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.thunderbird.enable [ pkgs.thunderbird ];

    config.home.preserve.directories = lib.mkIf config.programs.thunderbird.enable [
      ".thunderbird"
      ".cache/thunderbird"
    ];

  };


}
