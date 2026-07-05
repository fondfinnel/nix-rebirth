{ self, inputs, config, ... }: {

  flake.nixosModules.common-utils = { lib, config, pkgs, ... }: {

    boot.loader.limine = {
      enable = true;
      additionalFiles = { "efi/memtest86/memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi"; };
      extraEntries =
        "/memtest86
        protocol: chainload
        path: boot():///efi/memtest86/memtest86.efi
      ";
    };
    boot.loader.efi.canTouchEfiVariables = true;
};


}
