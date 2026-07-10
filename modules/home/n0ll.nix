{ self, inputs, config, ... }: let
  system = config.nixpkgs.hostPlatform;
  check = config.device-type == "primary";
in {

  flake.nixosModules.users = { pkgs, lib, config, ... }: {
    
    users.users.n0ll = {
      isNormalUser = true;
      description = "Nathaniel Fagan";
      extraGroups = [ "uinput" "networkmanager" "wheel" "cdrom" "libvirtd" "kvm" "dialout" "tty" ];
        shell = pkgs.fish;
        home = "/home/n0ll";
        hashedPasswordFile = config.sops.secrets."users/n0ll".path;
        openssh.authorizedKeys.keyFiles = lib.filesystem.listFilesRecursive ../../keys/n0ll;
        # uncomment when installing fresh system
        # initialPassword = "123";
    };

    sops.secrets."users/n0ll" = rec {
      owner = config.users.users.n0ll.name;
      group = config.users.users.n0ll.group;
      neededForUsers = true;      
    };

    programs.fish.enable = true;

    users.groups.libvirtd.members = [ "n0ll" ];
    programs.weylus.users = ["n0ll"];

    # only necessary for importing home-manager as nixos-module
    environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

    # likely removing once things are finalized, for testing purposes
    home-manager.users.n0ll.imports = [
      self.homeModules.n0ll-conf
    ];

  };

  flake.homeConfigurations.n0ll = inputs.home-manager.lib.homeManagerConfiguration {
    # use architecture from system
    pkgs = import inputs.nixpkgs { system = system; };

    modules = with self.homeModules; [
      n0ll-conf
    ];
  };

  flake.homeModules.n0ll-conf = { pkgs, osConfig, config, lib, ... }: {

    imports = with self.homeModules; [
      hyprland
      kitty
      common-utils
      gaming
      creative
      development
      keepassxc
      mpd
      firefox
      sync-drive
      qbittorrent
      syncthing
    ];

    home.sessionVariables = {
      EDITOR = "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emac";
    };

    home.shellAliases = {
      nshp = "nix-shell -p"; # installing programs temporarily
      ":q" = "exit";
      blkid = "sudo blkid";
    };

    sops = {
      defaultSopsFile = ./n0ll-secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      age.sshKeyPaths = [
        config.sops.secrets."ssh".path
        config.sops.secrets."ssh-basilisk".path
        config.sops.secrets."ssh-gekko".path
      ];
      validateSopsFiles = true;

      secrets."ssh".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      secrets."ssh-basilisk".path = "${config.home.homeDirectory}/.ssh/id_basilisk";
      secrets."ssh-gekko".path = "${config.home.homeDirectory}/.ssh/id_gekko";

      secrets."lastfm".name = "lastfm";
      secrets."syncthing/gui".name = "syncthing-gui";
      secrets."syncthing/${osConfig.networking.hostName}/cert".name = "syncthing-cert";
      secrets."syncthing/${osConfig.networking.hostName}/key".name = "syncthing-key"; 
    };

    home.preserve.directories = [
      ".config/nix-rebirth"
      ".config/sops"
    ];

    stylix = {
      opacity = {
        terminal = 0.9;
        popups = 0.9;
      };

      fonts = rec {
        serif = monospace;
        sansSerif = monospace;
        emoji = monospace;

        monospace = {
          package = pkgs.nerd-fonts.sauce-code-pro;
          name = "SauceCodePro Nerd Font Mono";
        };

        sizes = {
          applications = 10;
          terminal = 9;
        };
      };
    };
    
    services.mpdscribble.endpoints."last.fm" = {
      username = "natervader13";
      passwordFile = config.sops.secrets."lastfm".path; 
    };

    programs.jujutsu.settings.user = {
      name = "Nathaniel Fagan";
      email = "natervader13@gmail.com";
    };

    programs.ssh.matchBlocks."git" = {
      host = "github.com codeberg.org";
      user = "git";
      identityFile = [
        "~/.ssh/id_basilisk"
        "~/.ssh/id_gekko"
        "~/.ssh/id_ed25519"
      ];
    };

    programs.ledger.enable = true;

    programs.rimsort.enable = osConfig.headless-check;

    programs.firefox.profiles."${config.home.username}" = {

      name = config.home.username;
      isDefault = true;

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

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [ 
        # uses rycee flake for extensions, check available ones with `nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"`
        sponsorblock
        # dearrow
        adnauseam
        vimium
        # ublock-origin
        # tridactyl
        darkreader
        indie-wiki-buddy
        augmented-steam
        keepassxc-browser
        youtube-high-definition
        simple-translate
        old-reddit-redirect
      ];

      extensions.settings = {
        # "adnauseam@rednoise.org" = {
        #   selectedFilterLists = [
        
        #   ];
        # };
      };

      userChrome = let
        repo =  pkgs.fetchFromGitHub {
          owner = "cascadefox";
          repo = "cascade";
          rev = "main";
          hash = "sha256-MW6E9OaTGlnbHMRl8svgIyqd7BzYOjvUYi92sdgxNCc=";
        };
        file = pkgs.concatTextFile {
          name = "userChrome.css";
          files = lib.lists.map (x: repo + "/chrome/includes/cascade-" + x) [
            "config.css"
            "colours.css"
            "layout.css"
            "responsive.css"
            "floating-panel.css"
            "nav-bar.css"
            "tabs.css"
          ];
        };
      in builtins.readFile file;
      

    };

  };

}
