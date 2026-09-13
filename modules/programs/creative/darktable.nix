{ self, inputs, config, ... }: {

  flake.homeModules.creative = { pkgs, lib, config, osConfig, ... }: let
    check = osConfig.headless-check;
  in {

    options.programs.darktable.enable = lib.mkEnableOption "darktable";
    config.programs.darktable.enable = lib.mkDefault check;

    config.home.packages = lib.mkIf config.programs.darktable.enable [
      pkgs.darktable
      pkgs.exiftool

      (lib.mkIf osConfig.hardware.amdgpu.opencl.enable pkgs.rocmPackages.migraphx)
    ];

    config.home.preserve.directories = [
      ".config/darktable"
    ];
  };


}
