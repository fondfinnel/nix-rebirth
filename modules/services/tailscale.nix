{ self, inputs, config, ... }: let
  check = !config.headless-check;
in {

  flake.nixosModules.common-utils = { lib, config, pkgs, ... }: {

    services.tailscale = {

      enable = lib.mkDefault true;

      extraSetFlags = [ # Sets launch options for tailscaled
        "--accept-routes"
        "--exit-node=100.117.167.110" # For Mullvad, choosing which exit node to use. Needs to be an actual IP or else tailscaled-set complains at boot.
        # To find another mullvad node, run `tailscale exit-node <list/suggest>`
        "--exit-node-allow-lan-access=true"
      ] ++ lib.optionals check [
        "--ssh"
      ];

      useRoutingFeatures =
        if check then "server"
        else "client";

      # TODO dynamic authentication
      # authKeyFile = config.sops.secrets."tailscale-auth".path;
    };

  };

}
