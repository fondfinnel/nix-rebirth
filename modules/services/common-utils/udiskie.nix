{
  self,
  inputs,
  config,
  ...
}:
{

  flake.nixosModules.common-utils =
    { lib, config, ... }:
    let
      check = config.headless-check;
    in
    {
      services.udisks2.enable = lib.mkDefault check;
    };

  flake.homeModules.common-utils =
    {
      pkgs,
      lib,
      osConfig,
      config,
      ...
    }:
    {

      # flash drive uses ntfs for performance
      home.packages = [ pkgs.ntfs3g ];

      # udiskie needs udisks2, which is only system scope
      # is not enabled if it's a server
      services.udiskie.enable = osConfig.services.udisks2.enable;
      services.udiskie.tray = "never";

    };

}
