{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.librewolf = { pkgs, config, lib, ... }: {

    programs.librewolf = {
      enable = lib.mkDefault false;

      # import the firefox config
      profiles."${config.home.username}" = config.programs.firefox.profiles."${config.home.username}" // {

        # errors if not defined here as well
        search.default = if check then "SearXNG" else "DuckDuckGo";
        search.engines = {
          # engine terms can be found here https://searchfox.org/mozilla-central/rev/669329e284f8e8e2bb28090617192ca9b4ef3380/toolkit/components/search/SearchEngine.jsm#1138-1177
          "SearXNG" = {
            urls = [{
              template = "http://local.nate.server:30053/?q={searchTerms}";
            }];
            definedAliases = [ "@s" ];
          };
        };

        settings = config.programs.firefox.profiles."${config.home.username}".settings // {

          # Librewolf tweaks
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown.cache" = false;
        };

      };

      policies = config.programs.firefox.policies;

    };

    home.preserve.directories = lib.mkIf config.programs.librewolf.enable [ "${config.home.homeDirectory}/.librewolf" ];

  };


}
