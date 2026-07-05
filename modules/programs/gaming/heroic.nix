{ self, inputs, config, ... }: {

  flake.homeModules.gaming = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check && osConfig.high-performance;
  in {

    options.programs.heroic.enable = lib.mkEnableOption "heroic";
    config.programs.heroic.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.heroic.enable [
      pkgs.heroic
      pkgs.gogdl
    ];

    config.home.preserve.directories = lib.mkIf config.programs.heroic.enable [
      ".config/heroic"
      ".local/share/heroic"
    ];


  };


}
