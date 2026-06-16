{ self, inputs, config, ... }: let
  check = config.headless-check && config.high-performance;
in {

  flake.homeModules.gaming = { pkgs, lib, config, ... }: {

    options.programs.pcsx2.enable = lib.mkEnableOption "pcsx2";
    config.programs.pcsx2.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.pcsx2.enable [ pkgs.pcsx2-bin ];

    # TODO confirm
    config.home.persistence."/persistent".directories = lib.mkIf config.programs.pcsx2.enable [
      "${config.xdg.configHome}/PCSX2"
      "${config.xdg.dataHome}/PCSX2"
    ];
 

  };


}
