{ self, inputs, config, ... }: {

  flake.homeModules.gaming = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check && osConfig.high-performance;
  in {

    options.programs.ryujinx.enable = lib.mkEnableOption "ryujinx";
    config.programs.ryujinx.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.ryujinx.enable [ pkgs.ryubing ];

  };


}
