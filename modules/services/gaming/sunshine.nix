{ self, inputs, config, ... }: let
  check = config.device-type == "primary";
in {

  flake.nixosModules.gaming = { lib, config, pkgs, ... }: {

    services.sunshine = lib.mkDefault rec {
      enable = check;
      autoStart = lib.mkDefault enable;
      settings = {
        sunshine_name = config.networking.hostName;
        port = 47989;
        credentials_file = config.sops.secrets."sunshine".path;
      };
      capSysAdmin = lib.mkDefault enable; # required for DRM/KMS screen capture
      openFirewall = lib.mkDefault enable;
    };

  };


}
