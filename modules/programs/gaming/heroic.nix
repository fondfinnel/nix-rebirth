{ self, inputs, config, ... }: let
  check = config.headless-check == config.high-performance;
in {

  flake.homeModules.gaming = { pkgs, lib, config, ... }: {

    options.programs.heroic.enable = lib.mkEnableOption "heroic";
    config.programs.heroic.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.heroic.enable [
      pkgs.heroic
      pkgs.gogdl
    ];

    config.home.persistence."/persistent".directories = lib.mkIf config.programs.heroic.enable [
      "${config.xdg.configHome}/heroic"
      "${config.xdg.dataHome}/heroic"
      "${config.home.homeDirectory}/Games/Heroic"
    ];


  };


}
