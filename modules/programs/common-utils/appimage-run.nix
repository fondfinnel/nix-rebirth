{ self, inputs, config, ... }: {

  flake.nixosModules.common-utils = { lib, pkgs, config, ... }: let
    check = config.headless-check;
  in {

    programs.appimage.enable = lib.mkDefault check;
    programs.appimage.binfmt = lib.mkDefault true;
    environment.systemPackages = lib.mkIf check [ pkgs.fuse ];

    boot.kernelModules = lib.mkIf check [ "fuse" ];

  };

}
