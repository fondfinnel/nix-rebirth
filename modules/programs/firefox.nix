{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.firefox = { pkgs, config, lib, ... }: {
    imports = [ self.homeModules.librewolf ];

    programs.firefox = {
      enable = lib.mkDefault (!config.programs.librewolf.enable && check);

      profiles."${config.home.username}".settings = { # Settings inside about:config, writes to user.js
        "browser.startup.homepage" =  "about:blank"; # Page that firefox sets home as
        "middlemouse.paste" = false;
        "general.autoScroll" = true;
        # "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "permissions.desktop-notification.notNow.enabled" = true;
        # "dom.webnotifications.enabled" = false;
        # "browser.shell.checkDefaultBrowser" = false;
        "extensions.autoDisableScopes" = 0; # Automatically enable addons
        # "browser.tabs.firefox-view" = false;
        # # Other privacy tweaks, courtesy of https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
        "extensions.formautofill.addresses_enabled" = false;
        "extensions.ui.locale.hidden" = true;
        "extensions.ui.mlmodel.hidden" = true;
        "extensions.ui.sitepermission.hidden" = true;
        "extensions.pocket.enabled" = false;
        "extensions.screenshots.disabled" = true;
        "extensions.pictureinpicture.enable_picture_in_picture_overrides" = false;
        "browser.topsites.contile.enabled" = false;
        "browser.formfill.enable" = false;
        # "browser.search.suggest.enabled" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.suggest.searches" = false;
        # "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          # # Enable user CSS
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "layers.acceration.force-enabled" = true;
          "layout.css.backdrop-filter.enabled" = true;
          "svg.context-properties.content.enabled" = true;
          "network.cookie.lifetimePolicy" = 0;
          "cookiebanners.service.mode" = 2; # block cookie banners
          "userChrome.autohide.back_button" = true;
          "userChrome.autohide.forward_button" = true;
        };


      policies = { # ref: https://mozilla.github.io/policy-templates/

        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        # EnableTrackingProtection = {
        #   Value = true;
        #   Locked = true;
        #   Cryptomining = true;
        #   Fingerprinting = true;
        # };
        DisablePocket = true;
        DisableFirefoxAccounts = false;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableFormHistory = true;
        # NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        PictureInPicture = false;
        AutofillCreditCardEnabled = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off";
        SearchBar = "unified";
      };

      };

    };


}
