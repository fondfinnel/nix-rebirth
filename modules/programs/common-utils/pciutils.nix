{ self, inputs, config, ... }: {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    options.programs.pciutils.enable = lib.mkEnableOption "pciutils";
    config.programs.pciutils.enable = lib.mkDefault true;

    config.home.packages = lib.mkIf config.programs.pciutils.enable [ pkgs.pciutils ];

  };


}
