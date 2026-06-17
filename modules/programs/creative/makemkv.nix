{ self, inputs, config, ... }: let
  check = config.high-performance;
in {

  flake.homeModules.creative = { pkgs, lib, config, osConfig, ... }: {

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

    # might be worth trying this alternatively
    # https://github.com/Mic92/sops-nix#templates

    config.sops.secrets."makemkv" = {
      path = "${config.home.homeDirectory}/.MakeMKV/settings.conf";
    };

  };


}
