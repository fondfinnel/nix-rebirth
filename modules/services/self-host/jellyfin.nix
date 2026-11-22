# Network layout for jfin pod
#
# +-------+---------------+----------+--------------+
# |PubPort|Service        |Scope     |File          |
# +-------+---------------+----------+--------------+
# |31010  |Jellyfin       |Localhost |./jellyfin.nix|
# |       |               |-> CF     |              |
# +-------+---------------+----------+--------------+
# |31111  |Tunarr WebGUI  |LAN       |./tunarr.nix  |
# |       |               |          |              |
# +-------+---------------+----------+--------------+
# |31012  |Wizarr         |Localhost |./jellyfin.nix|
# |       |               |-> CF     |              |
# +-------+---------------+----------+--------------+

{
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
      mainDir = "/Apps/jellyfin";
    in
    {

      # ensure required directories are available, created as root
      systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 1000 1000") [
        "${mainDir}"
        "${mainDir}/config"
        "${mainDir}/cache"
        "${mainDir}/upscale-models"
        "${mainDir}/wizarr"
        "${mainDir}/audiomuse"
      ];

      # module requires quadlet-nix
      imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

      virtualisation.quadlet =
        let
          inherit (config.virtualisation.quadlet) networks pods;
        in
        {
          enable = true;

          containers.jellyfin = {
            # serviceConfig.TimeoutStartSec = "60";
            containerConfig = {
              image = "docker.io/jellyfin/jellyfin:latest";
              pull = "newer";
              pod = pods.jfin.ref;

              # necessary with pod?
              # networks = [
              #   "podman"
              #   networks.internal.ref
              # ];

              environments = {
                LOG_LEVEL = "INFO";
                TZ = config.time.timeZone;

                # enable nvidia acceleration with nvidia GPU
                NVIDIA_VISIBLE_DEVICES = lib.mkIf config.hardware.nvidia.modesetting.enable "all";
              };

              devices = [ "/dev/dri" ];

              volumes = [
                "${mainDir}/config:/config" # redirect config storage
                "${mainDir}/cache:/cache" # redirect cache storage
                "/Primary/Personal/Media:/Media"
              ];

            };
          };

          # containers.jellyfin-ai-upscaler.containerConfig = {
          #   image = "docker.io/kuscheltier/jellyfin-ai-upscaler:docker7-intel";
          #   pull = "newer";
          #   pod = pods.jfin.ref;

          #   # opens 5000/tcp internally, no external access

          #   devices = [ "/dev/dri" ];

          #   volumes = [
          #     "${mainDir}/upscale-models:/app/models"
          #   ];

          #   # required for vulkan, intel arc
          #   extraOptions = [
          #     "--group-add=render"
          #   ];

          #   environments = {
          #     LOG_LEVEL = "INFO";
          #     TZ = config.time.timeZone;
          #     PUID = "1000";
          #     GUID = "1000";
          #     API_TOKEN = "disable";
          #   };

          # };

          containers.wizarr.containerConfig = {
            image = "ghcr.io/wizarrrr/wizarr:latest";
            pull = "newer";
            pod = pods.jfin.ref;

            volumes = [
              "${mainDir}/wizarr:/data"
            ];
            environments = {
              TZ = config.time.timeZone;
              # enable when using external auth (authelia, tinyauth, etc)
              DISABLE_BUILTIN_AUTH = "false";
              PUID = "1000";
              GUID = "1000";
            };

          };

          pods.jfin.podConfig.publishPorts = [
            # publish jellyfin
            "127.0.0.1:31010:8096"

            # wizarr
            "127.0.0.1:31012:5690"
          ];

        };

      services.cloudflared.tunnels."20717350-c41e-4cbc-9ece-bd9a47c3865b".ingress = {
        "jellyfin.nniche.uk" = "http://localhost:31010";
        "jellyinv.nniche.uk" = "http://localhost:31012";
      };

    };

}
