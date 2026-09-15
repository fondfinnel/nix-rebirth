{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    # TODO add secrets for cloudflared
    sops.secrets."cloudflared/cred".name = "cloudflared-cred";
    sops.secrets."cloudflared/cert".name = "cloudflared-cert";

    # requires setting up dns cname rules manually atm
    # might automate with script

    services.cloudflared = {
      enable = true;
      certificateFile = config.sops.secrets."cloudflared/cert".path;
      tunnels = {
        "20717350-c41e-4cbc-9ece-bd9a47c3865b" = {
          default = "http_status:404";
          credentialsFile = config.sops.secrets."cloudflared/cred".path;
          ingress = {
            "fireshare.nniche.uk" = "http://localhost:1337";
          };
        };
      };
    };

  };


}
