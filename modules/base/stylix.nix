{ self, inputs, config, ... }: {

  flake.nixosModules.base = { lib, config, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = lib.mkDefault true;
      autoEnable = lib.mkDefault true;

      base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";

      cursor = lib.mkDefault {
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
        size = 24;
      };
    };
  };

  flake.homeModules.base = { lib, osConfig, pkgs, ... }: {

    stylix = let d = lib.mkDefault; in {
      enable = d osConfig.stylix.enable;

      base16Scheme = d osConfig.stylix.base16Scheme;

    };

  };


}
