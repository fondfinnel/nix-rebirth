{ self, inputs, config, ... }: let
  check = config.high-performance;
in {

  # TODO SOPS

  flake.homeModules.creative = { pkgs, lib, config, ... }: {

    options.programs.makemkv.enable = lib.mkEnableOption "makemkv";
    config.programs.makemkv.enable = lib.mkDefault check;

    config.home.packages =  with pkgs; lib.mkIf (config.programs.makemkv.enable == true) [
      makemkv
      tvnamer
      mktoolnix

      mediainfo

      libdvdcss
      libbluray
      libaacs
      libbdplus
    ];

  };


}
