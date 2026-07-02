{ self, inputs, config, ... }: {

  flake.nixosModules.base = { lib, config, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = lib.mkDefault true;
      autoEnable = lib.mkDefault true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyodark.yaml";
    };
  };

  flake.homeModules.base = { lib, osConfig, pkgs, ... }: {

    stylix = let d = lib.mkDefault; in {
      enable = d osConfig.stylix.enable;

      base16Scheme = d osConfig.stylix.base16Scheme;

    };

  };


}
