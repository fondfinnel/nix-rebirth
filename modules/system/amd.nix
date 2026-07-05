{ self, inputs, config, ... }: {

  flake.nixosModules.amd = { lib, config, pkgs, ... }: {

    # Enable kernel module
    boot.initrd.kernelModules = [ "amdgpu" ];
    # Enable xserver to use module
    services.xserver.videoDrivers = [ "amdgpu" ];

    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; # latest kernel has best AMD support
    boot.kernelParams = ["split_lock_detect=off"];

    # # Certain programs using the gpu for acceleration uses a library called HIP. This enables it better.
    systemd.tmpfiles.rules = [ "L+  /opt/rocm/hip  -  -  -  - ${pkgs.rocmPackages.clr}" ];

    hardware = {

      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
      };

      # Extra packages, support and shit
      graphics = {
        extraPackages = with pkgs; [
          rocmPackages.clr
          libva
          libva-utils
          libva-vdpau-driver
        ];
        enable = true;
        enable32Bit = true;
      };
    };

    # systemd.packages = [pkgs.lact]; # overclocking utility
    # systemd.services.lactd.wantedBy = ["multi-user.target"];

    environment.systemPackages = with pkgs; [
      # lact
      mesa
      vulkan-tools
      clinfo
      # mesa-demos
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-runtime
    ];

    home-manager.sharedModules = [{
      programs.btop.package = pkgs.btop-rocm;
    }];

  };


}
