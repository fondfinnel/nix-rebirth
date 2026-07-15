{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/path/to/dir";

  in {

    # ensure dirs are available for containers
    system.activationScripts.pre-015.deps = [ "specialfs" ];
    system.activationScripts.pre-015.text = '' mkdir -p ${mainDir}/uploads '';

    virtualisation.oci-containers.containers = let
      pull = "newer";
      # worker and app use the same vols apparently
      volumes = [
        "${mainDir}/uploads:/uploads"
        "${mainDir}/config.yaml:/config.yaml"
      ];
    in {
      pull = "newer";
      # worker and app use the same vols apparently
      volumes = [
        "${mainDir}/uploads:/uploads"
        "${mainDir}/config.yaml:/config.yaml"
      ];

      "015-app" = {

        image = "fudaoyuanicu/015-app";
        inherit pull volumes;
        ports = [ "31100:80" ];
        dependsOn = [ "015-redis" ];

      };

      "015-worker" = {

        inherit pull volumes;
        image = "fudaoyuanicu/015-worker";
        dependsOn = [
          "015-app"
          "015-redis"
        ];

      };

      "015-redis" = {
        inherit pull;
        image = "redis:7";

      };

    };

  };


}
