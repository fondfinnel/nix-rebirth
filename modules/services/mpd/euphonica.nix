{ self, inputs, config, ... }: {

  flake.homeModules.mpd = { config, osConfig, lib, pkgs, ... }: {

    options.programs.euphonica.enable = lib.mkEnableOption "euphonica";
    config.programs.euphonica.enable = lib.mkDefault (osConfig.headless-check && config.services.mpd.enable);

    config.home.packages = lib.mkIf (config.programs.euphonica.enable == true) [ pkgs.euphonica ];

    config.home.preserve.directories = [ ".cache/euphonica" ];

  };


}
