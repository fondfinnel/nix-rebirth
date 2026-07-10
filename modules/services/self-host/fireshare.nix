{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: let
    mainDir = "/path/to/dir";
  in {

    sops.secrets."fireshare".name = "fireshare";

    virtualization.oci-containers.containers.fireshare = {
      image = "shaneisrael/fireshare";
      ports = [
        # untested
        "127.0.0.1:1337:80"
      ];

      volumes = [
        # TODO get dirs
        "${mainDir}/data:/data"
        "${mainDir}/processed:/processed"
        "${mainDir}/videos:/videos"
        "${mainDir}/images:/images"
      ];

      environmentFiles = [ config.sops.secrets."fireshare".path ];

    };

  };


}
