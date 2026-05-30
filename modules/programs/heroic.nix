{ self, inputs, config, ... }: let
  check = config.high-performance;
in {

  flake.homeModules.gaming = { pkgs, lib, config, ... }: {

    options.programs.heroic.enable = lib.mkEnableOption "heroic";
    config.programs.heroic.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf (config.programs.heroic.enable == true) [ pkgs.heroic ];

  };


}
