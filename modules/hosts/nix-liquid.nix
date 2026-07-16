{ self, inputs, ... }: {

  # Import modules as if root of flake
  flake.nixosConfigurations.nix-liquid = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.nix-liquid-conf
      self.nixosModules.nix-liquid-hw
      self.nixosModules.share-nas

      self.nixosModules.bluetooth 
      self.nixosModules.kanata
    ];

  };

  # Most changes for system here
  flake.nixosModules.nix-liquid-conf = { pkgs, lib, config, ... }: {

    networking.hostName = "nix-liquid";
    nixpkgs.hostPlatform = "x86_64-linux";

    device-type = "secondary";

    hardware.keyboard.zsa.enable = true;
    hardware.keyboard.qmk.enable = true;

    home-manager.sharedModules = [
      { services.mic-volume.enable = true; }
      {
        
      wayland.windowManager.hyprland.settings = {
            monitor = [
              "eDP-1, preferred, auto, 1"
            ];
            bind = [ # disable or enable mousepad manually
              "SUPER SHIFT ALT CTRL, t, exec, hyprctl keyword 'device[synaptics-tm3276-022]:enabled' false & notify-send 'Touchpad disabled'"
              "SUPER SHIFT ALT, t, exec, hyprctl keyword 'device[synaptics-tm3276-022]:enabled' true & notify-send 'Touchpad enabled'"
            ];
          };
      }
    ];

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-dark.yaml";

    imports = [
      self.nixosModules.users
    ];

  };

  # Changes from hardware-configuration.nix
  flake.nixosModules.nix-liquid-hw = { pkgs, lib, config,... }: {

    imports = [

      # declare partition scheme
      self.nixosModules.disko-preservation
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480

    ];

    disko.devices.disk.main.device = "/dev/sda";

  };  


}
