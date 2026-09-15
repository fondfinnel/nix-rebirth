{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/services/jellyfin";
  in {
 
    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 1000 1000") [
      "${mainDir}"
      "${mainDir}/config"
      "${mainDir}/cache"
      "${mainDir}/upscale-models"
    ];


    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

    virtualisation.oci-containers.containers.jellyfin = {
      image = "docker.io/jellyfin/jellyfin";
      pull = "newer";
      ports = [
        "127.0.0.1:31010:8096" 
      ];


      devices = [
        "/dev/dri:/dev/dri"
      ];

      volumes = [
        "${mainDir}/config:/config" # redirect config storage
        "${mainDir}/cache:/cache" # redirect cache storage
        # TODO change media dir
        "/Primary/Personal/Media:/Media:ro" # read only for media
      ];

      environment = {
        LOG_LEVEL = "INFO";
        TZ = config.time.timeZone;
        NVIDIA_VISIBLE_DEVICES = lib.mkIf config.hardware.nvidia.modesetting.enable "all";
      };

    };

    virtualisation.oci-containers.containers.jellyfin-ai-upscaler = {
      # change branch depending on hw
      image = "docker.io/kuscheltier/jellyfin-ai-upscaler:docker7-cpu";
      pull = "newer";

      # with aardvark (podman), no need to open port
      # ports = [
      #   "31011:5000" 
      # ];

      # devices = [ "/dev/dri" ];

      volumes = [
        "${mainDir}/upscale-models:/models" 
      ];

      # required for vulkan, intel arc
      # extraOptions = [
      #   "--group-add=render"
      # ];

      environment = {
        LOG_LEVEL = "INFO";
        TZ = config.time.timeZone;
        PUID = "1000";
        GUID = "1000";
        API_TOKEN = "disable";
      };


    };

    virtualisation.oci-containers.containers.jellyfin-wizarr = {
      image = "ghcr.io/wizarrrr/wizarr:latest";
      ports = [
        "127.0.0.1:31012:5690"
      ];
      volumes = [
        "${mainDir}/wizarr"
      ];
      environment = {
        TZ = config.time.timeZone;

        # enable when using external auth (authelia, tinyauth, etc)
        DISABLE_BUILTIN_AUTH = "false";
        PUID = "1000";
        GUID = "1000";
      };
    };

    services.cloudflared.tunnels."20717350-c41e-4cbc-9ece-bd9a47c3865b".ingress = {
      "jellyfin.nniche.uk" = "http://localhost:31010";
      "jellyinv.nniche.uk" = "http://localhost:31012";
    };

  };


}
