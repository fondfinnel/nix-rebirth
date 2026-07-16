{ self, inputs, ... }: {

  flake.nixosConfigurations.nix-heaven = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.nix-heaven-conf
      self.nixosModules.nix-heaven-hw
      self.nixosModules.users
      self.nixosModules.self-host
    ];
  };

  flake.nixosModules.nix-heaven-conf = { lib, config, pkgs, ... }: {

    networking.hostName = "nix-heaven";
    nixpkgs.hostPlatform = "x86_64-linux";

    device-type = "server";
    high-performance = true;
    headless-check = false;

    # head -c 8 /etc/machine-id
    networking.hostId = "";

    power.ups = {
      enable = true;
      mode = "standalone";
      ups.main = {
        description = "tbd";

        # see wiki for list of drivers
        driver = "tbd";

        port = "auto";

        directive = [
          "offdelay = 60"
          "ondelay = 90"
          "lowbatt = 40"
          # "ignorelb"
        ];
      };
    };

  };

  flake.nixosModules.nix-heaven-hw = { lib, config, pkgs, ... }: {
    fileSystems."/" =
      { device = "/dev/by-label/temp";
        fsType = "ext4";
      };

  };



}
