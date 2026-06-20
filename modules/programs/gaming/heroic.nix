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

    config.home.preserve.directories = lib.mkIf config.programs.heroic.enable [
      ".config/heroic"
      ".local/share/heroic"
      "${config.home.homeDirectory}/Games/Heroic"
    ];


  };


}
