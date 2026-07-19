{ self, inputs, config, ... }: {

  flake.nixosModules.self-host = { lib, config, pkgs, ... }: {

    sops.secrets."neko".name = "neko";

    virtualisation.oci-containers.containers.neko = let
      # TODO dir
      mainDir = "/path/to/dir";
    in {

      image = "m1k1o/neko";
      pull = "newer";
      ports = [
        "8080:8080" 
        "52000-52100:52000-52100/udp"
      ];

      # TODO dir
      # volumes = [
      #   "${mainDir}:/home/neko/.mozilla/firefox" # redirect config storage
      # ];

      environment = {
        NEKO_DESKTOP_SCREEN = "1920x1080@60";
        NEKO_CAPTURE_BROADCAST_AUDIO_BITRATE = "192";
        NEKO_WEBRTC_EPR = "52000-52100";
        NEKO_WEBRTC_ICELITE = "1";
      };

      environmentFiles = [ config.sops.secrets."neko".path ];

    };

  };

}
