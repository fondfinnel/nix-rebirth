{ self, inputs, config, ... }: let
  check = config.headless-check;
  highperf = config.high-performance;
in {

  flake.homeModules.creative = { lib, pkgs, ... }: {

    home.packages = lib.mkIf highperf [
      pkgs.kdePackages.kdenlive
      pkgs.mediainfo
    ];

  };


}
