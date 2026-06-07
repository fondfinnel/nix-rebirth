{ self, inputs, config, ... }: let
  check = config.device-type == "server";
in {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    services.searx = {
      enable = true;
      # TODO sops
      # environmentFile = config.sops.secrets."searx".path;
      settings.server = {
        port = "8888";
        bind_address = "0.0.0.0";
        # secret_key = "$SEARX_SECRET";
      };
    };

  };


}
