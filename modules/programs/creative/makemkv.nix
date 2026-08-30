{ self, inputs, config, ... }: {

  flake.nixosModules.base = { ... }: {
    # required for optical drive detection
    # may need to run `modprobe sg`
    environment.etc."modules-load.d/sg.conf" = {
      enable = true;
      text = ''sg'';
    };
  };

  flake.homeModules.creative = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.high-performance;
  in {

    options.programs.makemkv.enable = lib.mkEnableOption "makemkv";
    config.programs.makemkv.enable = lib.mkDefault check;

    config.home.packages =  with pkgs; lib.mkIf config.programs.makemkv.enable [
      makemkv
      tvnamer
      mkvtoolnix

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

    config.home.preserve.directories = [ ".MakeMKV" ];

  };


}
