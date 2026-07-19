# TODO dir
# TODO paperless-gpt
# TODO paperless-ai
{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/path/to/dir";
  in {

    system.activationScripts.pre-015.deps = [ "specialfs" ];
    system.activationScripts.pre-015.text = ''mkdir -p ${mainDir}/data ${mainDir}/media ${mainDir}/export ${mainDir}/consume ${mainDir}/redis'';

    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    virtualisation.oci-containers.containers = {

      paperless-ngx = {
        
        image = "paperlessngx/paperless-ngx";
        pull = "newer";
        ports = [
          "127.0.0.1:20000:8000" 
        ];

        # TODO dir
        volumes = [
          "${mainDir}/data:/usr/src/paperless/data"
          "${mainDir}/media:/usr/src/paperless/media"
          #   "./export:/usr/src/paperless/export"
          #   "./consume:/usr/src/paperless/consume"
        ];

        environment = {
          PAPERLESS_REDIS = "redis://paperless-redis:6379";
        };
      };

      paperless-redis = {
        image = "redis:8";
        dependsOn = [ "paperless-ngx" ];
        volumes = [ "${mainDir}/redis:/data" ];
      };

    };

  };


}
