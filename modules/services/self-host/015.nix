{ self, inputs, config, ... }: {

  flake.nixosModules."015" = { lib, config, pkgs, ... }: let
    mainDir = "/home/n0ll/numbersnumbers";

  in {

    # systemd.tmpfiles.rules = lib.map (f: "d ${f} 1664 n0ll users") [
    #     "${mainDir}/uploads"
    # ];

    system.activationScripts.pre-015.deps = [ "specialfs" ];
    system.activationScripts.pre-015.text = '' mkdir -p ${mainDir}/uploads'';


    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.containers = let
      pull = "newer";
      # worker and app use the same vols apparently
      volumes = [
        "${mainDir}/uploads:/uploads"
        "${./config.yaml}:/app/config.yaml"
      ];
    in {

      "015-app" = {

        image = "fudaoyuanicu/015-app";
        inherit pull volumes extraOptions;
        ports = [ "31100:80" ];
        dependsOn = [ "015-redis" ];

        environment.REDIS_URL = "redis://015-redis:6379";
        # TODO sops secrets

      };

      "015-worker" = {

        inherit pull extraOptions;
        image = "fudaoyuanicu/015-worker";
        volumes = [
          "${mainDir}/uploads:/uploads"
          "${./config.yaml}:/config.yaml"
        ];
        dependsOn = [
          "015-app"
          "015-redis"
        ];

      };

      "015-redis" = {
        inherit pull extraOptions;
        image = "redis:7";

      };

    };

  };


}
