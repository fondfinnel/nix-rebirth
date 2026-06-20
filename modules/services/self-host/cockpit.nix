{ self, inputs, config, ... }: let
  check = config.device-type == "server";
in {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    services.cockpit = {
      enable = lib.mkDefault check;
      port = 33333;
      openFirewall = true;

      # TODO push zfs plugin to zfs module instead
      plugins = with pkgs; [
        cockpit-machines
        cockpit-zfs
        cockpit-podman
      ];

      settings = lib.mkDefault {
        WebService.AllowUnencrypted = true;
        WebService.Origins = "http://localhost:33333 https://localhost:33333";
      }; 

    };

  };


}
