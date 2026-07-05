{ self, inputs, config, ... }:  {

  flake.nixosModules.virt-manager = { pkgs, lib, config, ... }: let
    check = config.high-performance;
  in {

    virtualisation = {
      libvirtd.enable = lib.mkDefault check;
      spiceUSBRedirection.enable = lib.mkDefault check;
    };

    programs.virt-manager.enable = lib.mkDefault check;

  };

}
