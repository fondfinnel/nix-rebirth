{ self, inputs, ... }: {
  flake.nixosModules.base = { lib, ... }:
    with lib; {

      options.device-type = lib.mkOption {
        description = ''
        Defaults for device type. One of:

        "primary"
        "secondary"
        "server"
        "virtual"
      '';
        type = lib.types.enum [
          "primary"
          "secondary"
          "server"
          "virtual"
        ]; 

        default = "secondary";
      };

  };
}
