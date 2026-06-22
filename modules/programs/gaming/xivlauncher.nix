{ self, inputs, config, ... }: let
  check = config.headless-check && config.high-performance;
in {

  flake.homeModules.gaming = { pkgs, lib, config, ... }: {

    options.programs.xivlauncher.enable = lib.mkEnableOption "xivlauncher";
    config.programs.xivlauncher.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.xivlauncher.enable [ pkgs.xivlauncher ];

  };


}
