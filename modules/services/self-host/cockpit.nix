{ self, inputs, config, ... }:  {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    check = config.device-type == "server";
  in{

    # so far, not working
    services.cockpit = rec {
      enable = lib.mkDefault false;
      port = 33333;
      openFirewall = true;

      # TODO push zfs plugin to zfs module instead
      plugins = with pkgs; [
        cockpit-machines
        # cockpit-zfs
        cockpit-podman
      ];

      settings = lib.mkDefault {
        WebService.AllowUnencrypted = true;
        WebService.Origins = "http://192.168.50.100:${port}";
      }; 

    };

  };


}
