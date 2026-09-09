{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/services/015";
    storeDir = "/Apps/015";
    exPort = "31100";
    exURL = "ohfifteen.nniche.uk";
  in {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${storeDir}/uploads"
      "${mainDir}/redis-data"
    ];

    sops.secrets."oh15" = {};

    # app requires config.yaml to work at all
    # env vars take priority over those values
    # see https://github.com/keven1024/015/issues/49#issuecomment-5549292841

    services.cloudflared.tunnels."20717350-c41e-4cbc-9ece-bd9a47c3865b".ingress."${exURL}" = "http://localhost:${exPort}";

    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.containers = let
      pull = "newer";

      # write text file for config into nix store, read as vol in container
      # toYAML -> writeTextFile -> path as vol mount 
      # TODO write secrets
      oh15-config = pkgs.writeTextFile
        { name = "oh15-config"; text =
            (lib.generators.toYAML { } {
              share.download_window = 12;
              redis.url = "redis://015-redis:6379";
              features = {
                file-share.enabled = true;
                text-share.enabled = true;
                file-image-compress.enabled = true;
                file-image-convert.enabled = true;
              };

              site = {
                title.en = "Niche File Share!";
                url = exURL;
                desc.en = "Temporary file sharing, powered by 015";
                # todo files
                # icon = "";
                # bg_url = "";
                enable_bg = true;
              };

              about = {
                bg_url = "";
                email = "";
                name = "";
                avatar = config.home-manager.users.n0ll.home.file.".face".source;
              }; 
            } );
        };
      environmentFiles = [ config.sops.secrets."oh15".path ];
      environment.TZ = config.time.timeZone;
    in {

      "015-app" = {
        inherit pull environmentFiles environment;
        image = "docker.io/fudaoyuanicu/015-app";
        volumes = [
          "${storeDir}/uploads:/uploads"
          "${oh15-config}:/app/config.yaml"
        ];
        ports = [ "127.0.0.1:${exPort}:80" ];
        dependsOn = [ "015-redis" ];

      };

      "015-worker" = {

        inherit pull environmentFiles environment;
        image = "docker.io/fudaoyuanicu/015-worker";
        volumes = [
          "${mainDir}/uploads:/uploads"
          "${oh15-config}:/config.yaml"
        ];
        dependsOn = [
          "015-app"
          "015-redis"
        ];

      };

      "015-redis" = {
        inherit pull environment;
        image = "docker.io/redis:7";
        volumes = [ "${mainDir}/redis-data:/data" ];

      };

    };

  };


}
