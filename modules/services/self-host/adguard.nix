{ self, inputs, config, ... }: let
  check = config.device-type == "server";
in {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    services.adguardhome = {
      enable = lib.mkDefault check;
      mutableSettings = lib.mkDefault true;
      port = 3000;
      settings = {
        theme = "dark";
        dns = {
          bind_hosts = "0.0.0.0";
          ratelimit = 0;
          cache_enabled = true;
        };
      };
    };

  };


}
