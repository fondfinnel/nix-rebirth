{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    config.programs.thunderbird.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.thunderbird.enable [ pkgs.thunderbird ];

    config.home.preserve.directories = lib.mkIf config.programs.thunderbird.enable [
      ".thunderbird"
      ".cache/thunderbird"
    ];

  };


}
