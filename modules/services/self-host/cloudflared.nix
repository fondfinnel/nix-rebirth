{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    # TODO add secrets for cloudflared
    sops.secrets."cloudflared/cred".name = "cloudflared-cred";
    sops.secrets."cloudflared/cert".name = "cloudflared-cert";

    services.cloudflared = {
      enable = true;
      tunnels = {
        "0c747775-3132-4cc5-9a2c-a1b6d5066997" = {
          default = "http_status:404";
          credentialsFile = config.sops.secrets."cloudflared/cred".path;
          ingress = {
            "jellyfin2.nniche.uk" = "http://localhost:8096";
            "fireshare.nniche.uk" = "http://localhost:1337";
          };
        };
      };
    };

  };


}
