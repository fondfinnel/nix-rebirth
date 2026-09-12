# TODO dir
# TODO paperless-gpt
# TODO paperless-ai
{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/services/paperless-ngx";
    storeDir = "/Primary/Personal/Documents";
  in {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/data"
      "${mainDir}/redis"
      "${storeDir}"
      "${storeDir}/paperless"
    ];

    sops.secrets."paperless-ngx" = {};

    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    virtualisation.oci-containers.containers = {

      paperless-ngx = {
        
        image = "docker.io/paperlessngx/paperless-ngx:latest";
        pull = "newer";
        ports = [
          "20000:8000" 
        ];

        # TODO dir
        volumes = [
          "${mainDir}/data:/usr/src/paperless/data"
          "${storeDir}/paperless:/usr/src/paperless/media"
          #   "./export:/usr/src/paperless/export"
          #   "./consume:/usr/src/paperless/consume"
        ];

        environment = {
          PAPERLESS_REDIS = "redis://paperless-redis:6379";
        };
        environmentFiles = [ config.sops.secrets."paperless-ngx".path ];
      };

      paperless-redis = {
        image = "docker.io/redis:8";
        dependsOn = [ "paperless-ngx" ];
        volumes = [ "${mainDir}/redis:/data" ];
      };
      paperless-ai = {
        image = "docker.io/clusterzx:latest";
        # exposes :3000 internally
        dependsOn = [ "paperless-ngx" ];
        # environmentFiles = [config.sops.secrets."paperless-ai".path];
        environment = {
          TZ = config.time.timeZone;
        };

      };

    };

  };


}
