{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { lib, pkgs, config, ... }: {

    options.programs.bottles.enable = lib.mkOption {
      type = lib.types.bool;
      default = check;
    };

    config.home.packages = lib.mkIf config.programs.bottles.enable [
      (pkgs.bottles.override { removeWarningPopup = true; })
    ];

    config.home.persistence."/persistent".directories = lib.mkIf config.programs.bottles.enable [ "${config.xdg.dataHome}/bottles" ];

  };


}
