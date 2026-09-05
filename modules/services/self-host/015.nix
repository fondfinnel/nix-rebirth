{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/services/015";
  in {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/upload"
    ];


    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.containers = let
      pull = "newer";
      # worker and app use the same vols apparently
      volumes = [
        "${mainDir}/uploads:/uploads"
        # TODO lib.generators.toYAML
        "${./015-config.yaml}:/app/015-config.yaml"
      ];
    in {

      "015-app" = {

        image = "docker.io/fudaoyuanicu/015-app";
        inherit pull volumes;
        ports = [ "31100:80" ];
        dependsOn = [ "015-redis" ];

        environment.REDIS_URL = "redis://015-redis:6379";
        # TODO sops secrets

      };

      "015-worker" = {

        inherit pull;
        image = "docker.io/fudaoyuanicu/015-worker";
        volumes = [
          "${mainDir}/uploads:/uploads"
          "${./015-config.yaml}:/015-config.yaml"
        ];
        dependsOn = [
          "015-app"
          "015-redis"
        ];

      };

      "015-redis" = {
        inherit pull;
        image = "docker.io/redis:7";

      };

    };

  };


}
