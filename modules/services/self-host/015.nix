{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/services/015";
    # oh15-config = ./015-config.yaml;
  in {

    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${mainDir}/uploads"
    ];

    # app needs config.yaml to work
    # env vars take priority over those values
    # see https://github.com/keven1024/015/issues/49#issuecomment-5549292841

    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.containers = let
      pull = "newer";

      oh15-config = lib.generators.toYAML { } {
        # password_salt and download_secret in envfile
        share.download_window = 12;
        redis.url = "redis://015-redis:6379";
        features = {
          file-share.enabled = true;
          text-share.enabled = true;
          file-image-compress.enabled = true;
          file-image-convert.enabled = true;
        };

        # site url defined in envfile
        site = {
          title.en = "Niche File Share!";
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
          avatar = "";
        };
        
      };
    in {

      "015-app" = {

        image = "docker.io/fudaoyuanicu/015-app";
        volumes = [
          "${mainDir}/uploads:/uploads"
          # TODO lib.generators.toYAML
          "${oh15-config}:/app/config.yaml"
        ];
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
          "${oh15-config}:/config.yaml"
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
