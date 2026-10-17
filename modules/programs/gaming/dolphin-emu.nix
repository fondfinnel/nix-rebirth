{ self, inputs, config, ... }: {

  flake.homeModules.gaming = { lib, config, osConfig, pkgs, ... }: let
    check = osConfig.headless-check;
  in {

    options.programs.dolphin-emu.enable = lib.mkEnableOption "dolphin-emu";
    config.programs.dolphin-emu.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf (config.programs.dolphin-emu.enable == true) [ pkgs.dolphin-emu ];

    config.home.preserve.directories = lib.mkIf config.programs.dolphin-emu.enable [ ".config/dolphin-emu" ];

  };


}
