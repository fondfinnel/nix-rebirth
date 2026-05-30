{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.speedtest-go.enable = lib.mkEnableOption "speedtest-go";
    config.programs.speedtest-go.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf config.programs.speedtest-go.enable [ pkgs.speedtest-go ];
    config.home.shellAliases.speedtest = "speedtest-go";

  };


}
