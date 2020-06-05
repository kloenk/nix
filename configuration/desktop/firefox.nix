{ lib, ... }:

{
  programs.firefox = {
    enable = true;
    policies = {
      Bookmarks = [
        {
          Title = "github";
          URL = "https://github.com";
          Placement = "menu";
        }
      ];
      Certificates.Install = [ ];
      Cookies.AcceptThirdParty = "from-visited";
      Cookies.RejectTracker = true;
      DisableSetDesktopBackground = true;
      DisableMasterPasswordCreation = true;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = false;
      DisablePocket = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSystemAddonUpdate = true;
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Cryptomining = true;
        Fingerprinting = true;
      };
      #EncryptedMediaExtensions.Enabled = true;
      Extensions = {
        Install = [
          #"https://addons.mozilla.org/firefox/downloads/file/3475706/matte_black_red-2019.12.27-an+fx.xpi"
          "https://addons.mozilla.org/firefox/downloads/file/3537075/dark_knight_joker-2020.3.29-an+fx.xpi"
          "https://addons.mozilla.org/firefox/downloads/file/3548609/firefox_multi_account_containers-6.2.5-fx.xpi"
          "https://addons.mozilla.org/firefox/downloads/file/3427772/browserpass-3.4.1-fx.xpi"
          "https://addons.mozilla.org/firefox/downloads/file/1209734/snooze_tabs-1.1.1-fx.xpi"
          "https://addons.mozilla.org/firefox/downloads/file/3581422/tridactyl-1.19.1-an+fx.xpi" # vim expirience
          "https://addons.mozilla.org/firefox/downloads/file/3582859/momentum-1.17.17-fx.xpi"
          "https://addons.mozilla.org/firefox/downloads/file/3539016/adblock_plus-3.8.4-an+fx.xpi"
        ];
        Locked = [
        ];
      };
      Homepage = {
        URL = "moz-extension://a8b3c9a1-063e-400b-848a-88a20688a837/dashboard.html";
        Locked = true;
        StartPage = "homepage";
      };
      NetworkPrediction = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      PSFjs.EnablePermissions = false;
      Permissions = {
        Microphone = {
          Allow = [ "https://meet.pbb.lc" ];
        };
        Notifications = {
          Block = [ "https://reddit.com" "https://youtube.com" ];
        };
      };
      Preferences = {
        "browser.fixup.dns_first_for_single_words" = true;
        "datareporting.policy.dataSubmissionPolicyBypassNotification" = true;
        "dom.event.contextmenu.enabled" = true;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        #security.default_personal_cert = "cert";
      };
      RequestedLocales = ["de" "en-US"];
      SSLVersionMin = "tls1.2";
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
      };
    };
  };
}
