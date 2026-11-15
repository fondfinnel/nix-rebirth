# TODO paperless-gpt
{
  self,
  inputs,
  config,
  ...
}:
{

  flake.nixosModules.self-host =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      mainDir = "/services/paperless-ngx";
      storeDir = "/Primary/Personal/Documents";
      tz = config.time.timeZone;
      textModel = "ministral-3:3b";
    in
    {

      systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 1000 1000") [
        "${mainDir}"
        "${mainDir}/data"
        "${mainDir}/redis"
        "${storeDir}"
        "${storeDir}/paperless"
      ];

      sops.secrets."paperless/ngx" = { };
      sops.secrets."paperless/ai" = { };
      # sops.secrets."paperless/gpt" = {};

      # module requires quadlet-nix
      imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

      virtualisation.quadlet.enable = true;

      # never leaving LAN
      virtualisation.quadlet.pods.paperless.podConfig = {
        publishPorts = [ "20000:8000" ];
      };

      virtualisation.quadlet.containers =
        let
          inherit (config.virtualisation.quadlet) networks pods;
          pod = pods.paperless.ref;
          pull = "newer";
          startWithPod = true;
        in
        {

          paperless-ngs.unitConfig = rec {
            Requires = [ "paperless-redis.service" ];
            After = Requires;
          };
          paperless-ngx.containerConfig = {
            inherit
              pod
              pull
              startWithPod
              ;

            image = "docker.io/paperlessngx/paperless-ngx:latest";

            volumes = [
              "${mainDir}/data:/usr/src/paperless/data"
              "${storeDir}/paperless:/usr/src/paperless/media"
              #   "./export:/usr/src/paperless/export"
              #   "./consume:/usr/src/paperless/consume"
            ];

            environments = {
              PAPERLESS_REDIS = "redis://localhost:6379";
              TZ = tz;

              # PAPERLESS_AI_ENABLED = "true";
              # PAPERLESS_AI_LLM_BACKEND = "ollama";
              # PAPERLESS_AI_LLM_ENDPOINT = "ollama:11434";
              # PAPERLESS_AI_LLM_MODEL = textModel;

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

          paperless-redis.containerConfig = {
            inherit
              pod
              pull
              startWithPod
              ;
            image = "docker.io/redis:8";
          };

          # TODO quadlet
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
