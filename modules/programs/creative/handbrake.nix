{ self, inputs, config, ... }: let
  check = config.headless-check && config.high-performance;
in {

  flake.homeModules.creative = { pkgs, lib, config, ... }: {

    options.programs.handbrake.enable = lib.mkEnableOption "handbrake";
    config.programs.handbrake.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.handbrake.enable [
      pkgs.handbrake
      pkgs.vidmerger
      pkgs.ffmpeg
      pkgs.mediainfo
    ];

  };


}
