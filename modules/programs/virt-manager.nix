{ self, inputs, config, ... }: let
  check = config.high-performance;
in {

  flake.nixosModules.virt-manager = { pkgs, lib, config, ... }: {

    virtualisation = {
      libvirtd.enable = lib.mkDefault check;
      spiceUSBRedirection.enable = lib.mkDefault check;
    };

    programs.virt-manager.enable = lib.mkDefault check;

  };

}
