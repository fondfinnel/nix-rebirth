{ self, inputs, ... }: {

  flake.nixosModules.bluetooth = { lib, config, ... }: {

    hardware.bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault config.hardware.bluetooth.enable;
    };
    services.blueman.enable = lib.mkDefault config.hardware.bluetooth.enable;

    environment.persistence."/persistent".directories = [ "/var/lib/bluetooth" ];

  };

  # home changes for devices with bluetooth
  # imported at base as shared module
  flake.homeModules.common-utils = { pkgs, osConfig, lib, ... }: {

    home.packages = lib.mkIf osConfig.hardware.bluetooth.enable [
      pkgs.bluetui
    ];

  };

}
