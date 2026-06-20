{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.gaming = { lib, config, pkgs, ... }: {

    options.programs.dolphin-emu.enable = lib.mkEnableOption "dolphin-emu";
    config.programs.dolphin-emu.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf (config.programs.dolphin-emu.enable == true) [ pkgs.dolphin-emu ];

    config.home.persistence."/persistent".directories = lib.mkIf config.programs.dolphin-emu.enable [ ".config/dolphin-emu" ];

  };


}
