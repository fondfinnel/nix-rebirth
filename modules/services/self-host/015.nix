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
      mainDir = "/services/015";
      storeDir = "/Apps/015";
      exPort = "31100";
      exURL = "ohfifteen.nniche.uk";
    in
    {

      imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

      systemd.tmpfiles.rules = lib.map (f: "d ${f} 0755 1000 1000") [
        "${mainDir}"
        "${storeDir}/upload"
      ];

      sops.secrets."oh15" = { };

      # app requires config.yaml to work at all
      # env vars take priority over those values
      # see https://github.com/keven1024/015/issues/49#issuecomment-5549292841

      services.cloudflared.tunnels."20717350-c41e-4cbc-9ece-bd9a47c3865b".ingress."${exURL}" =
        "http://localhost:${exPort}";

      virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

      virtualisation.quadlet.enable = true;
      virtualisation.quadlet.pods.ohfifteen.podConfig = {
        publishPorts = [ "${exPort}:80" ];
      };
      virtualisation.quadlet.containers =
        let
          pull = "newer";
          startWithPod = true;

          # write text file for config into nix store, read as vol in container
          # toYAML -> writeTextFile -> path as vol mount
          # TODO write secrets
          oh15-config = pkgs.writeTextFile {
            name = "oh15-config";
            text = (
              lib.generators.toYAML { } {
                share.download_window = 12;
                redis.url = "redis://localhost:6379";
                features = {
                  file-share.enabled = true;
                  text-share.enabled = true;
                  file-image-compress.enabled = true;
                  file-image-convert.enabled = true;
                };

                upload = {
                  path = "/upload";
                  maximum = "100GiB";
                };

                site = {
                  title.en = "Niche File Share!";
                  url = "https://${exURL}";
                  desc.en = "Temporary file sharing, powered by 015";
                  # todo files
                  # icon = "";
                  # bg_url = "";
                  enable_bg = true;
                };

                # about = {
                #   bg_url = "";
                #   email = "";
                #   name = "";
                #   avatar = config.home-manager.users.n0ll.home.file.".face".source;
                # };
              }
            );
          };
          environmentFiles = [ config.sops.secrets."oh15".path ];
          environments.TZ = config.time.timeZone;
          pod = pods.ohfifteen.ref;
          inherit (config.virtualisation.quadlet) networks pods;

        in
        {

          "015-app" = {
            unitConfig.After = [ "015-redis.service" ];
            unitConfig.Requires = [ "015-redis.service" ];
            containerConfig = {
              inherit
                pull
                environmentFiles
                environments
                pod
                startWithPod
                ;
              image = "docker.io/fudaoyuanicu/015-app:latest";
              volumes = [
                "${storeDir}/upload:/upload"
                "${oh15-config}:/app/config.yaml"
              ];
              # ports = [ "127.0.0.1:${exPort}:80" ];
            };

          };

          "015-worker" = {
            unitConfig.After = [
              "015-redis.service"
              "015-app.service"
            ];
            unitConfig.Requires = [
              "015-redis.service"
              "015-app.service"
            ];
            containerConfig = {
              inherit
                pull
                environmentFiles
                environments
                pod
                startWithPod
                ;
              image = "docker.io/fudaoyuanicu/015-worker:latest";
              volumes = [
                "${storeDir}/upload:/upload"
                "${oh15-config}:/config.yaml"
              ];
            };
          };

          "015-redis".containerConfig = {
            inherit
              pull
              environments
              pod
              startWithPod
              ;
            image = "docker.io/redis:7";

          };

        };

    };

}
