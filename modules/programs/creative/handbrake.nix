{ self, inputs, config, ... }: {

  flake.homeModules.creative = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check && osConfig.high-performance;
  in {

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
