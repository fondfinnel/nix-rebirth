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
      mainDir = "/services/fireshare";
      storDir = "/Apps/fireshare";
      exPort = "1337";
    in
    {

      imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

      sops.secrets."fireshare" = { };

      # fireshare configured for other uid gid
      systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 1000 100") [
        "${mainDir}"
        "${mainDir}/data"
        "${mainDir}/processed"
        "${storDir}/videos"
        "${storDir}/images"
      ];

      services.cloudflared.tunnels."20717350-c41e-4cbc-9ece-bd9a47c3865b".ingress."fireshare.nniche.uk" =
        "http://localhost:${exPort}";

      virtualisation.quadlet =
        let
          inherit (config.virtualisation.quadlet) networks pods;
        in
        {
          enable = true;
          containers.fireshare = {
            serviceConfig.TiemoutStartSec = "60";
            containerConfig = {
              image = "docker.io/shaneisrael/fireshare:1.8.5";
              pull = "newer";
              environmentFiles = [ config.sops.secrets."fireshare".path ];
              networks = [
                "podman"
                networks.internal.ref
              ];
              publishPorts = [
                "127.0.0.1:${exPort}:80"
              ];
              devices = [ "/dev/dri" ];
              volumes = [
                "${mainDir}/data:/data"
                "${mainDir}/processed:/processed"
                "${storDir}/videos:/videos"
                "${storDir}/images:/images"
              ];
            };
          };
        };

      virtualisation.oci-containers.containers.jellyfin.volumes = [ "${storDir}:/fireshare" ];

    };

}
