{ self, inputs, config, ... }: let
  check = config.headless-check;
in {

  flake.homeModules.common-utils = { pkgs, lib, config, ... }: {

    programs.vesktop = {
      enable = lib.mkDefault check;

      # client settings
      settings = lib.mkIf config.programs.vesktop.enable {
        discordBranch = "stable";
        autoUpdateNotification = false;
        arRPC = true;
        disableMinSize = true;
        tray = true;
        enableSplashScreen = true;
        splashTheming = true;
        splashPixelated = true;
        audio.ignoreVirtual = true;
      };

      # vencord additional options
      vencord = lib.mkIf config.programs.vesktop.enable {

        # Use theme
        settings.themeLinks = [
          # dark matter https://betterdiscord.app/theme/Dark%20Matter
          # "https://discordstyles.github.io/DarkMatter/DarkMatter.theme.css"

          # system24 https://betterdiscord.app/theme/system24
          # "https://refact0r.github.io/system24/build/system24.css"

          # midnight https://betterdiscord.app/theme/midnight
          # "https://refact0r.github.io/midnight-discord/build/midnight.css"

          # minimalcord
          "https://raw.githubusercontent.com/DiscordStyles/MinimalCord/deploy/MinimalCord.theme.css"
        ];

        settings.plugins = lib.mkDefault {
          AlwaysTrust.enabled = true;
          AnonymiseFileNames.enabled = true;
          AlwaysExpandRoles.enabled = true;
          AlwaysAnimate.enabled = true;

          BetterFolders = {
            enabled = true;
            sidebarAnim = false;
            closeAllFolders = true;
            showFolderIcon = "Never";
          };
          BetterSettings.enabled = true;
          BlurNSFW.enabled = true;
          # BetterGifPicker.enabled = true;
          BetterRoleDot.enabled = true;
          BetterUploadButton.enabled = true;
          BetterRoleContext.enabled = true;

          CallTimer.enabled = true;
          ClearURLs.enabled = true;
          ConsoleJanitor.enabled = true;
          CrashHandler.enabled = true;

          DisableCallIdle.enabled = true;
          DontRoundMyTimestamps.enabled = true;

          FakeNitro.enabled = true;
          FriendsSince.enabled = true;
          ForceOwnerCrown.enabled = true;
          FullUserInChatbox.enabled = true;

          GameActivityToggle.enabled = true;
          GifPaste.enabled = true;

          IrcColors.enabled = true;
          ImplicitRelationships.enabled = true;

          LoadingQuotes.enabled = true;

          MutualGroupDMs.enabled = true;
          MemberCount.enabled = true;
          MessageLinkEmbeds.enabled = true;
          MessageLogger = {
            enabled = true;
            collapseDeleted = true;
            ignoreBots = true;
            ignoreSelf = true;
          };
          MentionAvatars.enabled = true;

          NoProfileThemes.enabled = true;
          NoTypingAnimation.enabled = true;
          NoF1.enabled = true;
          NoOnboardingDelay.enabled = true;
          NoPendingCount.enabled = true;

          OnePingPerDM.enabled = true;

          petpet.enabled = true;
          PlainFolderIcon.enabled = true;
          PlatformIndicators.enabled = true;

          QuickReply.enabled = true;
          QuickMention.enabled = true;

          ReplyTimestamp.enabled = true;

          ShowMeYourName.enabled = true;
          ShikiCodeblocks.enabled = true;

          Translate.autoTranslate = false;
          Translate.enabled = true;
          TypingTweaks.enabled = true;

          USRBG.enabled = true;

          VoiceMessages.enabled = true;
          VolumeBooster.enabled = true;

          WhoReacted.enabled = true;

          YoutubeAdblock.enabled = true;

        };
      };
    };

    # TODO impermanence

  };


}
