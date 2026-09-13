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
      host = "10.88.0.1";
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

          PAPERLESS_AI_ENABLED = "true";
          PAPERLESS_AI_LLM_BACKEND = "ollama";
          PAPERLESS_AI_LLM_ENDPOINT = "http://host.containers.internal:${builtins.toString config.services.ollama.port}";
          PAPERLESS_AI_LLM_MODEL = textModel;

          SCAN_INTERVAL = "*/30 * * * *";
          PROCESS_PREDEFINED_DOCUMENTS = "no";
          PROCESS_ONLY_NEW_DOCUMENTS = "no";
          ADD_AI_PROCESSED_TAG = "yes";

          ACTIVATE_TAGGING = "yes";
          ACTIVATE_CORRESPONDENTS = "yes";
          ACTIVATE_TITLE = "yes";
          ACTIVATE_DOCUMENT_TYPE = "yes";
        };
        environmentFiles = [ config.sops.secrets."paperless/ngx".path ];
      };

      paperless-redis = {
        image = "docker.io/redis:8";
        dependsOn = [ "paperless-ngx" ];
        volumes = [ "${mainDir}/redis:/data" ];
        environment.TZ = tz;
      };

      # paperless-ai = {
      #   image = "docker.io/clusterzx/paperless-ai:latest";
      #   # exposes :3000 internally
      #   dependsOn = [ "paperless-ngx" ];
      #   environmentFiles = [ config.sops.secrets."paperless/ai".path ];
      #   environment = rec {
      #     TZ = tz;
      #     # inherits the same val
      #     PAPERLESS_URL = "http://paperless-ngx:8000";
      #     PAPERLESS_NGX_URL = PAPERLESS_URL;
      #     PAPERLESS_HOST = PAPERLESS_URL;
      #     PAPERLESS_API_URL = "${PAPERLESS_URL}/api";

#           # read vals directly

      #             
      #   };

    };

  };

}
