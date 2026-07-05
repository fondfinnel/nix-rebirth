{ self, inputs, config, ... }: {

  flake.homeModules.gaming = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check && osConfig.high-performance;
  in {

    options.programs.xivlauncher.enable = lib.mkEnableOption "xivlauncher";
    config.programs.xivlauncher.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.xivlauncher.enable [ pkgs.xivlauncher ];

    config.home.preserve.directories = lib.mkIf config.programs.xivlauncher.enable [ ".xlcore" ];

  };


}
