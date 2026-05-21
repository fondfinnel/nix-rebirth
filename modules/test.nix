{ inputs, ... }: {
  flake.nixosModules.test = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.hello ];
    devShells.default = pkgs.mkShell {
      buildInputs = [ pkgs.hello ];
    };
  };
}
