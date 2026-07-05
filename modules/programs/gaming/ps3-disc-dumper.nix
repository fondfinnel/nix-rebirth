{ self, inputs, config, ... }: {

  flake.homeModules.gaming = { osConfig, config, lib, pkgs, ... }: let
    check = osConfig.headless-check && osConfig.high-performance;
  in {

    options.programs.ps3-disc-dumper.enable = lib.mkEnableOption "ps3-disc-dumper";
    config.programs.ps3-disc-dumper.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.ps3-disc-dumper.enable [ pkgs.ps3-disc-dumper ];


  };


}
