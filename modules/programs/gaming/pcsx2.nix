{ self, inputs, config, ... }: let
  check = config.headless-check && config.high-performance;
in {

  flake.homeModules.gaming = { pkgs, lib, config, ... }: {

    options.programs.pcsx2.enable = lib.mkEnableOption "pcsx2";
    config.programs.pcsx2.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.pcsx2.enable [ pkgs.pcsx2-bin ];

    config.home.preserve.directories = lib.mkIf config.programs.pcsx2.enable [
      ".config/PCSX2"
    ];
 

  };


}
