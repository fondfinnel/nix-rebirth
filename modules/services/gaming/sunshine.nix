{ self, inputs, config, ... }: {

  flake.nixosModules.gaming = { lib, config, pkgs, ... }: let
    check = config.device-type == "primary";
  in {

    services.sunshine = rec {
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

    sops.secrets."sunshine" = {      
      owner = config.users.users.root.name;
      group = config.users.users.root.group;
    }; 

    home-manager.sharedModules = [{
      home.preserve.directories = [
        ".config/sunshine"
      ];
    }];

  };


}
