{ self, inputs, config, ... }: {

  flake.nixosModules.nvidia = { lib, config, pkgs, ... }: {

    # Allow unfree packages if not already enabled, required for proprietary NVIDIA drivers.
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = [ 
      pkgs.cudaPackages.cudatoolkit 
      pkgs.nvtopPackages.nvidia 
    ];
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    services.sunshine.package = pkgs.sunshine.override { cudaSupport = lib.mkDefault config.hardware.nvidia.modesetting.enable; }; # required for nvidia cards using sunshine

  };


}
