{ lib, config, ... }: let
  isheadless = lib.types.enum [
    "server"
    "virtual"
  ];
in {

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

  options.headless-check = lib.mkOption {
    type = lib.types.bool; 
    description = "Is this device intended to have a desktop environment? True for a desktop, false for headless (to simplify logic elsewhere).";
    default = if config.device-type != isheadless then true else false;
  };

  options.high-performance = lib.mkOption {
    type = lib.types.bool;
    description = "Does this computer have good resources? Defaults to false for non-server stuff.";
    default = if config.device-type == "primary" then true else false;
  };

}
