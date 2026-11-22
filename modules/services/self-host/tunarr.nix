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
      mainDir = "/services/tunarr";
    in
    {

      systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
        "${mainDir}"
        "${mainDir}/config"
      ];

      # module requires quadlet-nix
      imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

      # see ./jellyfin.nix for pod ref
      virtualisation.quadlet =
        let
          inherit (config.virtualisation.quadlet) networks pods;
        in
        {

          containers.tunarr.containerConfig = {
            image = "docker.io/chrisbenincasa/tunarr:latest";
            pull = "newer";
            pod = pods.jfin.ref;

            devices = [
              "/dev/dri:/dev/dri"
            ];

            volumes = [
              "${mainDir}/config:/config/tunarr" # redirect config storage
              "/Primary/Personal/Media:/Media:ro" # read only for media
            ];

            environments = {
              LOG_LEVEL = "INFO";
              TZ = config.time.timeZone;
              NVIDIA_VISIBLE_DEVICES = lib.mkIf config.hardware.nvidia.modesetting.enable "all";
            };

          };

          pods.jfin.podConfig.publishPorts = [ "31111:8000" ];

        };

    };

}
