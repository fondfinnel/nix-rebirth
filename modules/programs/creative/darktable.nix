{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.creative = { pkgs, lib, config, osConfig, ... }: {

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
