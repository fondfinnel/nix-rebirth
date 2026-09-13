{ self, inputs, config, ... }: {

  flake.nixosModules.common-utils = { lib, config, pkgs, ... }: {
      
    sops.secrets."tailscale/client" = {};
    sops.secrets."tailscale/server" = {};

    services.tailscale = {

      enable = lib.mkDefault true;

      extraSetFlags = [ # Sets launch options for tailscaled
        "--accept-routes"
      ] ++ lib.optionals (!config.headless-check) [
        "--ssh"
      ] ++ lib.optionals (config.device-type == "primary") [ 
        "--exit-node=100.117.167.110" # For Mullvad, choosing which exit node to use. Needs to be an actual IP or else tailscaled-set complains at boot.
        # To find another mullvad node, run `tailscale exit-node <list/suggest>`
        "--exit-node-allow-lan-access=true"
      ];

      useRoutingFeatures =
        if !config.headless-check then "server"
        else "client";

      # TODO dynamic authentication
      authKeyFile = if config.device-type == "primary"
                    then config.sops.secrets."tailscale/client".path
                    else if !config.headless-check
                    then config.sops.secrets."tailscale/server".path
                    else null;
    };

    environment.preserve.directories = [
      "/var/lib/tailscale/"
    ];

  };

}
