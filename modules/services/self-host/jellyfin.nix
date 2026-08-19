
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


    # systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
    #   "/services/jellyfin-ai/models"
    # ];

    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

    virtualisation.oci-containers.containers.jellyfin = {
      image = "docker.io/jellyfin/jellyfin";
      pull = "newer";
      ports = [
        "31010:8096" 
        "127.0.0.1:7359:7359" 
      ];


      devices = [
        "/dev/dri:/dev/dri"
      ];

      # TODO dir
      volumes = [
        "${mainDir}/config:/config" # redirect config storage
        "${mainDir}/cache:/cache" # redirect cache storage
        "/home/n0ll/Videos:/media:ro" # read only for media
      ];

      environment = {
        LOG_LEVEL = "INFO";
        TZ = config.time.timeZone;
        NVIDIA_VISIBLE_DEVICES = lib.mkIf config.hardware.nvidia.modesetting.enable "all";
        PUID = "1000";
        GUID = "1000";
      };

    };

    virtualisation.oci-containers.containers.jellyfin-ai-upscaler = {
      # change branch depending on hw
      image = "docker.io/kuscheltier/jellyfin-ai-upscaler:docker7-cpu";
      pull = "newer";
      ports = [
        "31011:5000" 
      ];

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

  };


}
