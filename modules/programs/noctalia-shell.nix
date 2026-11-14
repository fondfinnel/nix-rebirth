{
  self,
  inputs,
  config,
  ...
}:
{

  flake.homeModules.noctalia-shell =
    {
      osConfig,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      enabled = osConfig.headless-check;
    in
    {

      programs.noctalia = {
        enable = enabled;
        # systemd.enabe = lib.mkDefault config.programs.noctalia.enable;
      };

    };

}
