{ self, inputs, config, ... }: {

  flake.nixosModules.base = { lib, config, pkgs, ... }: let
    check = config.headless-check;
  in {

    services.openssh.enable = lib.mkDefault true;
    services.openssh.authorizedKeysInHomedir = true;
    services.envfs.enable = lib.mkDefault check;

    security.polkit.enable = true;
    security.polkit.adminIdentities = [ "unix-group:wheel" ];
    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      validateSopsFiles = true;

      age.sshKeyPaths = if config.preservation.enable then [ "/persist/etc/ssh/ssh_host_ed25519_key" ]
                        else [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.keyFile = if config.preservation.enable then "/persist/var/lib/sops-nix/key.txt"
                    else "/var/lib/sops-nix/key.txt";
      age.generateKey = true;

      secrets = let
        sopsFile = ./host-secrets.yaml;
        reloadUnits = [ "syncthing.service" ];
      in {
        "${config.networking.hostName}/syncthing/cert" = { inherit sopsFile reloadUnits; };
        "${config.networking.hostName}/syncthing/key" = { inherit sopsFile reloadUnits; };
      };

    };
    environment.systemPackages = with pkgs; [
      yubioath-flutter # gui tool
      yubikey-manager # cli tool `ykman`
      pam_u2f # yubikey + sudo
    ];

    services.udev.packages = [ pkgs.yubikey-personalization ]; # extra cli tools for yubikeys
    services.pcscd.enable = true; # smart card module, for usb detection
    services.yubikey-agent.enable = config.security.pam.yubico.enable; # yubikey ssh support

    security.pam = lib.mkDefault {
      services = {
        # login and sudo access with yubikey
        login.u2fAuth = true;
        sudo.u2fAuth = true;
        sudo.sshAgentAuth = true;
      };
      yubico = {
        enable = true;
        # debug = true;
        mode = "challenge-response";
        id = [
          "32740781" # basilisk
          "32738578" # gekko
        ];
      };
      u2f = {
        enable = true;
        settings.cue = true;
        settings.authFile = "${config.users.users.n0ll.home}/.config/Yubico/u2f_keys";
      };
    };

    environment.preserve.files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/var/lib/sops-nix/key.txt"
    ];
    
  };

  flake.homeModules.base = { pkgs, ... }: {

    home.packages = [
      pkgs.sops
    ];

  };

}
