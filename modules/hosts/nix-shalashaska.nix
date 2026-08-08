{ self, inputs, ... }: {

  # Import modules as if root of flake
  flake.nixosConfigurations.nix-shalashaska = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.nix-shalashaska-conf
      self.nixosModules.nix-shalashaska-hw
      self.nixosModules.share-nas

      self.nixosModules.bluetooth 
      self.nixosModules.kanata
    ];

  };

  # Most changes for system here
  flake.nixosModules.nix-shalashaska-conf = { pkgs, lib, config, ... }: {

    networking.hostName = "nix-shalashaska";
    nixpkgs.hostPlatform = "x86_64-linux";

    device-type = "secondary";
    programs.steam.enable = true;

    home-manager.sharedModules = [
      { services.mic-volume.enable = true; }
      {
        wayland.windowManager.hyprland.plugins = [
          # pkgs.hyprlandPlugins.hyprgrass
          # pkgs.hyprlandPlugins.hyprspace
        ];
        
        wayland.windowManager.hyprland.settings = {

          monitor = [
            "desc:eDP-1, preferred, auto, 1" # primary monitor
            "desc:, preferred, auto, 1, mirror, eDP-1" # mirror to other monitors
          ];

          bind = [ # disable or enable mousepad manually
            "SUPER SHIFT ALT CTRL, t, exec, hyprctl keyword 'device[synaptics-tm3276-022]:enabled' false & notify-send 'Touchpad disabled'"
            "SUPER SHIFT ALT, t, exec, hyprctl keyword 'device[synaptics-tm3276-022]:enabled' true & notify-send 'Touchpad enabled'"
          ];

          exec-once = [
            "${pkgs.iio-hyprland}/bin/iio-hyprland"
          ];


        };

        programs.makemkv.enable = false;
        programs.obs-studio.enable = false;
        programs.ps3-disc-dumper.enable = false;
        programs.qbittorrent.enable = false;
        programs.calibre.enable = false;
      }
    ];

    high-performance = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";

    imports = [
      self.nixosModules.users
    ];


  };

  # Changes from hardware-configuration.nix
  flake.nixosModules.nix-shalashaska-hw = { pkgs, lib, config,... }: {

    imports = [

      # declare partition scheme
      self.nixosModules.disko-preservation

      # untested
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga

    ];

    boot.kernelModules = [
      "iwlwifi"
      "kvm-intel"
    ];

    hardware.cpu.intel.updateMicrocode = true;
    
    disko.devices.disk.main.device = "/dev/nvme0n1";

  };  


}
