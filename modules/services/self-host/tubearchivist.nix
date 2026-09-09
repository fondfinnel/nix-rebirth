{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    # TODO get dir
    mainDir = "/services/tubearchivist";
    storDir = "/Apps/tubearchivist";
  in {

    sops.secrets."tubearchivist" = {};
    sops.secrets."tubearchivist-es" = {};
    
    # ensure dirs are available for containers
    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
      "${mainDir}"
      "${storDir}/youtube"
      "${mainDir}/cache"
      "${mainDir}/redis-data"
      "${mainDir}/elast-data"
    ];
    
    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
    virtualisation.oci-containers.containers.tubearchivist = {
      
      image = "docker.io/bbilly1/tubearchivist"; 
      pull = "newer";

      ports = [ "127.0.0.1:31000:8000" ];
      volumes = [
        "${storDir}/youtube:/youtube"
        "${mainDir}/cache:/cache"
      ];

      environment.TZ = config.time.timeZone;
      environmentFiles = [ config.sops.secrets."tubearchivist".path ];

      dependsOn = [
        "tubearchivist-redis"
        "tubearchivist-es"
      ];

    };

    virtualisation.oci-containers.containers.tubearchivist-redis = {
      image = "docker.io/redis";
      pull = "newer";
      volumes = [ "${mainDir}/redis-data:/data" ];
      dependsOn = [ "tubearchivist-es" ];
    };
    
    # may need to run on directory
    # chown 1000:0 -R /dir
    virtualisation.oci-containers.containers.tubearchivist-es = {
      image = "docker.io/bbilly1/tubearchivist-es";
      pull = "newer";
      volumes = [ "${mainDir}/elast-data:/usr/shared/elasticsearch/data" ];
      environmentFiles = [ config.sops.secrets."tubearchivist-es".path ];
      # ports = [ "127.0.0.1:31002:9200" ];
    };

    services.cloudflared.tunnels."20717350-c41e-4cbc-9ece-bd9a47c3865b".ingress."ta.nniche.uk" = "http://localhost:31000";

  };
}
