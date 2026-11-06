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
      mainDir = "/services/neko";
    in
    {

      imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

      systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 root root") [
        "${mainDir}"
      ];

      sops.secrets."neko".name = "neko";

      virtualisation.quadlet =
        let
          # I have no clue how this actually works yet
          # but I guess it does, thanks https://seiarotg.github.io/quadlet-nix
          inherit (config.virtualisation.quadlet) networks pods;
        in
        {
          enable = true;
          containers.neko = {
            serviceConfig.TiemoutStartSec = "60";
            containerConfig = {
              image = "docker.io/m1k1o/neko";
              pull = "newer";
              environmentFiles = [ config.sops.secrets."neko".path ];
              networks = [
                "podman"
                networks.internal.ref
              ];
              publishPorts = [
                "8080:8080"
                "52000-52100:52000-52100/udp"
              ];
              environments = {
                NEKO_DESKTOP_SCREEN = "1920x1080@60";
                NEKO_CAPTURE_BROADCAST_AUDIO_BITRATE = "192";
                NEKO_WEBRTC_EPR = "52000-52100";
                NEKO_WEBRTC_ICELITE = "1";
              };
            };
          };
        };

    };

}
