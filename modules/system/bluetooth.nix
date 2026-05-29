{ self, inputs, ... }: {

  flake.nixosModules.bluetooth = { lib, ... }: {

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;

  };

  # home changes for devices with bluetooth
  # imported at base as shared module
  flake.homeModules.bluetooth = { pkgs, osConfig, lib, ... }: let
    check = osConfig.hardware.bluetooth.enable;
  in {

    home.packages = lib.mkIf check [
      pkgs.bluetui
    ];

  };
}
