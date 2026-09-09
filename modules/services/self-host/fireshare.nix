{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    # TODO dir
    mainDir = "/services/fireshare";
    storDir = "/Apps/fireshare";
  in {

    sops.secrets."fireshare" = {};

    # fireshare configured for other uid gid
    systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 1000 100") [
      "${mainDir}"
      "${mainDir}/data"
      "${mainDir}/processed"
      "${storDir}/videos"
      "${storDir}/images"
    ];

    virtualisation.oci-containers.containers.fireshare = {
      image = "docker.io/shaneisrael/fireshare";
      ports = [
        # untested
        "127.0.0.1:1337:80"
      ];

      volumes = [
        "${mainDir}/data:/data"
        "${mainDir}/processed:/processed"
        "${storDir}/videos:/videos"
        "${storDir}/images:/images"
      ];

      environmentFiles = [ config.sops.secrets."fireshare".path ];

    };

  };


}
