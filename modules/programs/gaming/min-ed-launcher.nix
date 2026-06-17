{ self, inputs, config, ... }: let
  check = config.headless-check == config.high-performance;
in {

  flake.homeModules.gaming = { pkgs, lib, config, ... }: {

    options.programs.min-ed-launcher.enable = lib.mkEnableOption "min-ed-launcher";
    config.programs.min-ed-launcher.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf (config.programs.min-ed-launcher.enable == true) [ pkgs.min-ed-launcher ];

    config.home.persistence."/persist".directories = [
      "${config.xdg.configHome}/min-ed-launcher"
    ];

  };


}
