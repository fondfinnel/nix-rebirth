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
      # TODO get dir
      mainDir = "/services/tubearchivist";
      storDir = "/Primary/Personal/Media/Internet";
    in
    {

      sops.secrets."tubearchivist" = { };

      # module requires quadlet-nix
      imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

      # ensure dirs are available for containers
      systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 1000 1000") [
        "${mainDir}"
        "${storDir}"
        "${mainDir}/cache"
        "${mainDir}/redis-data"
        "${mainDir}/elast-data"
      ];

      virtualisation.quadlet.enable = true;

      virtualisation.quadlet.pods.tubearchivist.podConfig = {
        publishPorts = [ "127.0.0.1:31000:8000" ];
      };

      virtualisation.quadlet.containers =
        let
          inherit (config.virtualisation.quadlet) networks pods;
          pod = pods.tubearchivist.ref;
          pull = "newer";
          startWithPod = true;
          environmentFiles = [ config.sops.secrets."tubearchivist".path ];
          environments.TZ = config.time.timeZone;
        in
        {

          tubearchivist-main.unitConfig = rec {
            Requires = [
              "tubearchivist-redis.service"
              "tubearchivist-es.service"
            ];
            After = Requires;
          };
          tubearchivist-main.containerConfig = {
            inherit
              pod
              pull
              environments
              environmentFiles
              startWithPod
              ;
            image = "docker.io/bbilly1/tubearchivist:latest";

            volumes = [
              "${storDir}:/youtube"
              "${mainDir}/cache:/cache"
            ];
          };

          tubearchivist-redis.unitConfig = rec {
            Requires = [ "tubearchivist-es.service" ];
            After = Requires;
          };
          tubearchivist-redis.containerConfig = {
            inherit
              pod
              pull
              environments
              environmentFiles
              startWithPod
              ;
            image = "docker.io/redis:latest";
            # user = "root";
          };

          # may need to run on directory
          # chown 1000:0 -R /dir
          tubearchivist-es.containerConfig = {
            inherit
              pod
              pull
              environments
              environmentFiles
              startWithPod
              ;
            image = "docker.io/bbilly1/tubearchivist-es:latest";
            volumes = [ "${mainDir}/elast-data:/usr/share/elasticsearch/data" ];
          };

        };

      services.cloudflared.tunnels."20717350-c41e-4cbc-9ece-bd9a47c3865b".ingress."ta.nniche.uk" =
        "http://localhost:31000";

    };
}
