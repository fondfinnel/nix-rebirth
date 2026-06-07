{ self, inputs, config, ... }: let
  check = config.headless-check == config.high-performance;
in {

  flake.homeModules.gaming = { pkgs, lib, config, ... }: {

    options.programs.ryujinx.enable = lib.mkEnableOption "ryujinx";
    config.programs.ryujinx.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.ryujinx.enable [ pkgs.ryubing ];

  };


}
