# TODO get dir working
# TODO paperless-gpt
{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/services/paperless-ngx";
    storeDir = "/Primary/Personal/Documents";
    tz = config.time.timeZone;
    textModel = "ministral-3:3b";
  in {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/data"
      "${mainDir}/redis"
      "${storeDir}"
      "${storeDir}/paperless"
    ];

    sops.secrets."paperless/ngx" = {};
    sops.secrets."paperless/ai" = {};
    # sops.secrets."paperless/gpt" = {};

    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      loadModels = [
        textModel
      ];
    };

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
          TZ = tz;
        };
        environmentFiles = [ config.sops.secrets."paperless/ngx".path ];
      };

      paperless-redis = {
        image = "docker.io/redis:8";
        dependsOn = [ "paperless-ngx" ];
        volumes = [ "${mainDir}/redis:/data" ];
        environment.TZ = tz;
      };

      paperless-ai = {
        image = "docker.io/clusterzx/paperless-ai:latest";
        # exposes :3000 internally
        dependsOn = [ "paperless-ngx" ];
        environmentFiles = [config.sops.secrets."paperless/ai".path];
        environment = rec {
          TZ = tz;
          PAPERLESS_URL = "http://paperless-ngx:8000";
          PAPERLESS_API_URL = "${PAPERLESS_URL}/api";

          AI_PROVIDER = "ollama";
          # read vals directly
          OLLAMA_API_URL = "http://${config.services.ollama.host}:${builtins.toString config.services.ollama.port}";
          OLLAMA_MODEL = textModel;

          SCAN_INTERVAL = "*/30 * * * *";
        };

      };

    };

  };


}
