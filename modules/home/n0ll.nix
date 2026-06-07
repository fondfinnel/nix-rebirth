{ self, inputs, config, ... }: let
  system = config.nixpkgs.hostPlatform;
  check = config.device-type == "primary";
in {

  flake.nixosModules.users = { pkgs, ... }: {
    
    users.users.n0ll = {
      isNormalUser = true;
      description = "Nathaniel Fagan";
      extraGroups = [ "uinput" "networkmanager" "wheel" "cdrom" "libvirtd" "kvm" "dialout" "tty" ];
      initialPassword = "123";
      shell = pkgs.fish;
      home = "/home/n0ll";
      # TODO hashedPassword
    };

    programs.fish.enable = true;

    users.groups.libvirtd.members = [ "n0ll" ];
    programs.weylus.users = ["n0ll"];

    # only necessary for importing home-manager as nixos-module
    environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

    # likely removing once things are finalized, for testing purposes
    home-manager.users.n0ll = { ... }: {
      imports = [
        self.homeModules.n0ll-conf
      ];

    };

  };

  flake.homeConfigurations.n0ll = inputs.home-manager.lib.homeManagerConfiguration {
    # use architecture from system
    pkgs = import inputs.nixpkgs { system = system; };

    modules = with self.homeModules; [
      n0ll-conf
    ];
  };

  flake.homeModules.n0ll-conf = { pkgs, osConfig, config, ... }: {

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
    ];

    home.sessionVariables = {
      EDITOR = "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emacs -nw";
    };

    home.shellAliases = {
      nshp = "nix-shell -p"; # installing programs temporarily
      ":q" = "exit";
      blkid = "sudo blkid";
    };

    programs.ledger.enable = true;

    services.mpdscribble.endpoints."last.fm" = {
      username = "natervader13";
      # TODO SOPS
      # passwordFile = osConfig.sops.secrets."keys/n0ll/lastfm".path; 
    };


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
        # adnauseam
        vimium
        ublock-origin
        tridactyl
        darkreader
        indie-wiki-buddy
        augmented-steam
        keepassxc-browser
        youtube-high-definition
        simple-translate
      ];

      extensions.settings = {
        # "adnauseam@rednoise.org" = {
        #   selectedFilterLists = [
        
        #   ];
        # };
      };


      userChrome = /*css*/ ''
            /*
            ┌─┐┬┌┬┐┌─┐┬  ┌─┐
            └─┐││││├─┘│  ├┤
            └─┘┴┴ ┴┴  ┴─┘└─┘
            ┌─┐┌─┐─┐ ┬
            ├┤ │ │┌┴┬┘
            └  └─┘┴ └─

            by Miguel Avila

            */

            /*

            ┌─┐┌─┐┌┐┌┌─┐┬┌─┐┬ ┬┬─┐┌─┐┌┬┐┬┌─┐┌┐┌
            │  │ ││││├┤ ││ ┬│ │├┬┘├─┤ │ ││ ││││
            └─┘└─┘┘└┘└  ┴└─┘└─┘┴└─┴ ┴ ┴ ┴└─┘┘└┘

            */

            :root {
              --sfwindow: #19171a;
              --sfsecondary: #201e21;
            }

            /* Urlbar View */

            /*─────────────────────────────*/
            /* Comment this section if you */
            /* want to show the URL Bar    */
            /*─────────────────────────────*/

            .urlbarView {
              display: none !important;
            }

            /*─────────────────────────────*/

            /*
            ┌─┐┌─┐┬  ┌─┐┬─┐┌─┐
            │  │ ││  │ │├┬┘└─┐
            └─┘└─┘┴─┘└─┘┴└─└─┘
            */

            /* Tabs colors  */
            #tabbrowser-tabs:not([movingtab])
              > #tabbrowser-arrowscrollbox
              > .tabbrowser-tab
              > .tab-stack
              > .tab-background[multiselected='true'],
            #tabbrowser-tabs:not([movingtab])
              > #tabbrowser-arrowscrollbox
              > .tabbrowser-tab
              > .tab-stack
              > .tab-background[selected='true'] {
              background-image: none !important;
              background-color: var(--toolbar-bgcolor) !important;
                                }

            /* Inactive tabs color */
            #navigator-toolbox {
              background-color: var(--sfwindow) !important;
            }

            /* Window colors  */
            :root {
              --toolbar-bgcolor: var(--sfsecondary) !important;
              --tabs-border-color: var(--sfsecondary) !important;
              --lwt-sidebar-background-color: var(--sfwindow) !important;
              --lwt-toolbar-field-focus: var(--sfsecondary) !important;
            }

            /* Sidebar color  */
            #sidebar-box,
            .sidebar-placesTree {
              background-color: var(--sfwindow) !important;
            }

            /*

            ┌┬┐┌─┐┬  ┌─┐┌┬┐┌─┐
             ││├┤ │  ├┤  │ ├┤
            ─┴┘└─┘┴─┘└─┘ ┴ └─┘
            ┌─┐┌─┐┌┬┐┌─┐┌─┐┌┐┌┌─┐┌┐┌┌┬┐┌─┐
            │  │ ││││├─┘│ ││││├┤ │││ │ └─┐
            └─┘└─┘┴ ┴┴  └─┘┘└┘└─┘┘└┘ ┴ └─┘

            */

            /* Tabs elements  */
            .tab-close-button {
              display: none;
            }

            /*
            .tabbrowser-tab:not([pinned]) .tab-icon-image {
              display: none !important;
            }
            */

            #nav-bar:not([tabs-hidden='true']) {
              box-shadow: none;
            }

            #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])
              > #tabbrowser-arrowscrollbox
              > .tabbrowser-tab[first-visible-unpinned-tab] {
              margin-inline-start: 0 !important;
              }

            :root {
              --toolbarbutton-border-radius: 0 !important;
              --tab-border-radius: 0 !important;
              --tab-block-margin: 0 !important;
            }

            .tab-background {
              border-right: 0px solid rgba(0, 0, 0, 0) !important;
              margin-left: -4px !important;
            }

            .tabbrowser-tab:is([visuallyselected='true'], [multiselected])
              > .tab-stack
              > .tab-background {
              box-shadow: none !important;
              }

            .tabbrowser-tab[last-visible-tab='true'] {
              padding-inline-end: 0 !important;
                            }

            #tabs-newtab-button {
              padding-left: 0 !important;
            }

            /* Url Bar  */
            #urlbar-input-container {
              background-color: var(--sfsecondary) !important;
              border: 1px solid rgba(0, 0, 0, 0) !important;
            }

            #urlbar-container {
              margin-left: 0 !important;
            }

            #urlbar[focused='true'] > #urlbar-background {
              box-shadow: none !important;
            }

            #navigator-toolbox {
              border: none !important;
            }

            /* Bookmarks bar  */
            .bookmark-item .toolbarbutton-icon {
              display: none;
            }
            toolbarbutton.bookmark-item:not(.subviewbutton) {
              min-width: 1.6em;
            }

            /* Toolbar  */
            #tracking-protection-icon-container,
            #urlbar-zoom-button,
            #star-button-box,
            #pageActionButton,
            #pageActionSeparator,
            #tabs-newtab-button,
            #back-button,
            #PanelUI-button,
            #forward-button,
            .tab-secondary-label {
              display: none !important;
            }

            .urlbarView-url {
              color: #dedede !important;
            }

            /* Disable elements  */
            #context-navigation,
            #context-savepage,
            #context-pocket,
            #context-sendpagetodevice,
            #context-selectall,
            #context-viewsource,
            #context-inspect-a11y,
            #context-sendlinktodevice,
            #context-openlinkinusercontext-menu,
            #context-bookmarklink,
            #context-savelink,
            #context-savelinktopocket,
            #context-sendlinktodevice,
            #context-searchselect,
            #context-sendimage,
            #context-print-selection {
              display: none !important;
            }

            #context_bookmarkTab,
            #context_moveTabOptions,
            #context_sendTabToDevice,
            #context_reopenInContainer,
            #context_selectAllTabs,
            #context_closeTabOptions {
              display: none !important;
            }

            /* Remove close button*/ .titlebar-buttonbox-container{ display:none }
          '';

      userContent = /* css */''
            /*
            ┌─┐┬┌┬┐┌─┐┬  ┌─┐
            └─┐││││├─┘│  ├┤
            └─┘┴┴ ┴┴  ┴─┘└─┘
            ┌─┐┌─┐─┐ ┬
            ├┤ │ │┌┴┬┘
            └  └─┘┴ └─

            by Miguel Avila

            */

            :root {
              scrollbar-width: none !important;
            }

            @-moz-document url(about:privatebrowsing) {
              :root {
                scrollbar-width: none !important;
              }
            }
       '';

    };

  };

}
