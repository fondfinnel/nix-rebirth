# A baseline any derivation is built from.
{ self, inputs, config, ... }: let
  check = config.headless-check;
in{

  flake.nixosModules.base = { lib, pkgs, config, ... }:
    with lib;
    {

      imports = [
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops

        self.nixosModules.common-utils
        self.nixosModules.greetd
        ./opts.nix
      ];


      config = {

        zramSwap = {
          enable = lib.mkDefault true;
          priority = 100;
          algorithm = "zstd";
          memoryPercent = 50;
        };

        system.stateVersion = "25.05";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        # required for good portion of software
        nixpkgs.config.allowUnfree = true;

        networking.networkmanager.enable = lib.mkDefault true;

        services.printing.enable = lib.mkDefault check;

        users.mutableUsers = false;

        security.polkit.enable = true;
        security.polkit.adminIdentities = [ "unix-group:wheel" ];
        sops = {
          defaultSopsFile = ./secrets.yaml;
          defaultSopsFormat = "yaml";
          validateSopsFiles = true;
          
          age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          age.keyFile = "/var/lib/sops-nix/key.txt";
          age.generateKey = true;
        };

        environment.preserve.directories = [
          config.sops.age.keyFile          
        ] ++ config.sops.age.sshKeyPaths;
        
      }; 

    };

}
