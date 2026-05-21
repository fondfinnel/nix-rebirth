{ self, inputs, ... }: {
  flake.nixosModules.nix-solid-conf = { pkgs, lib, ... }: {

    imports = [ self.nixosModules.base ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    environment.systemPackages = [ pkgs.hello ];
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    device-type = "pingas";

  };
}
