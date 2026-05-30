{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.tomato-c.enable = lib.mkEnableOption "tomato-c";
    config.programs.tomato-c.enable = lib.mkDefault false;

    config.home.packages = lib.mkIf config.programs.tomato-c.enable [ pkgs.tomato-c ];

  };


}
