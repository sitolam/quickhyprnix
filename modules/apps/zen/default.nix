{
  # options,
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.zen;
in
{
  options.apps.zen = {
    enable = lib.mkEnableOption "Enable zen browser";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];

      xdg.mimeApps =
        let
          associations = builtins.listToAttrs (
            map
              (name: {
                inherit name;
                value =
                  let
                    zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
                  in
                  zen-browser.meta.desktopFileName;
              })
              [
                "application/x-extension-shtml"
                "application/x-extension-xhtml"
                "application/x-extension-html"
                "application/x-extension-xht"
                "application/x-extension-htm"
                "x-scheme-handler/unknown"
                "x-scheme-handler/mailto"
                "x-scheme-handler/chrome"
                "x-scheme-handler/about"
                "x-scheme-handler/https"
                "x-scheme-handler/http"
                "application/xhtml+xml"
                "application/json"
                "text/plain"
                "text/html"
                "application/pdf"
              ]
          );
        in
        {
          associations.added = associations;
          defaultApplications = associations;
          enable = true;
        };

      programs.zen-browser = {
        enable = true;

        policies =
          let
            mkLockedAttrs = builtins.mapAttrs (
              _: value: {
                Value = value;
                Status = "locked";
              }
            );

            mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

            mkExtensionEntry =
              {
                id,
                pinned ? false,
              }:
              let
                base = {
                  install_url = mkPluginUrl id;
                  installation_mode = "force_installed";
                };
              in
              if pinned then base // { default_area = "navbar"; } else base;

            mkExtensionSettings = builtins.mapAttrs (
              _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
            );
          in
          {
            AutofillAddressEnabled = true;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true; # save webs for later reading
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            OfferToSaveLogins = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            SanitizeOnShutdown = {
              FormData = true;
              Cache = true;
            };
            NoDefaultBookmarks = true;

            ExtensionSettings = mkExtensionSettings {
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = mkExtensionEntry {
                id = "bitwarden-password-manager";
                pinned = true;
              };
              "uBlock0@raymondhill.net" = "ublock-origin";
              "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
              "{1b84391e-7c49-4ff3-abab-07bd0a4523e4}" = "multiselect-for-youtube";
              "enhancerforyoutube@maximerf.addons.mozilla.org" = "enhancer-for-youtube";
              "sponsorBlocker@ajay.app" = "sponsorblock";
              "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
              # "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
              "gitzip-firefox-addons@gitzip.org" = "gitzip";
              "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";
              "github-no-more@ihatereality.space" = "github-no-more";
              "github-repository-size@pranavmangal" = "gh-repo-size";
              "firefox-extension@steamdb.info" = "steam-database";
              "{861a3982-bb3b-49c6-bc17-4f50de104da1}" = "custom-user-agent-revived";
              "{jid0-YQz0l1jthOIz179ehuitYAOdBEs@jetpack}" = "print-friendly-and-pdf";
              # "{30b15d56-b2fa-4cb2-98fd-7b5e26306483}" = "stayfree";
            };
            Preferences = mkLockedAttrs {
              "browser.aboutConfig.showWarning" = false;
              "browser.tabs.warnOnClose" = false;
              "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
              # Disable swipe gestures (Browser:BackOrBackDuplicate, Browser:ForwardOrForwardDuplicate)
              "browser.gesture.swipe.left" = "";
              "browser.gesture.swipe.right" = "";
              "browser.tabs.hoverPreview.enabled" = true;
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.topsites.contile.enabled" = false;

              "privacy.resistFingerprinting" = true;
              "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
              "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
              "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
              "privacy.resistFingerprinting.block_mozAddonManager" = true;
              "privacy.spoof_english" = 1;

              "privacy.firstparty.isolate" = true;
              "network.cookie.cookieBehavior" = 5;
              "dom.battery.enabled" = false;

              "gfx.webrender.all" = true;
              "network.http.http3.enabled" = true;
              "network.socket.ip_addr_any.disabled" = true; # disallow bind to 0.0.0.0
            };
          };

        profiles.default = rec {
          settings = {
            "zen.workspaces.continue-where-left-off" = true;
            "zen.workspaces.natural-scroll" = true;
            "zen.view.compact.hide-tabbar" = true;
            "zen.view.compact.hide-toolbar" = true;
            "zen.view.compact.animate-sidebar" = false;
            "zen.welcome-screen.seen" = true;
            "zen.urlbar.behavior" = "float";
          };

          # bookmarks = {
          #   force = true;
          #   settings = [
          #     {
          #       name = "Nix sites";
          #       toolbar = true;
          #       bookmarks = [
          #         {
          #           name = "homepage";
          #           url = "https://nixos.org/";
          #         }
          #         {
          #           name = "wiki";
          #           tags = ["wiki" "nix"];
          #           url = "https://wiki.nixos.org/";
          #         }
          #       ];
          #     }
          #   ];
          # };

          pinsForce = true;
          pins = {
            "GitHub" = {
              id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
              workspace = spaces."Personal".id;
              url = "https://github.com";
              position = 101;
              isEssential = false;
            };
            "YouTube" = {
              id = "48e8a119-5a14-3464-9545-91c8e8dd3bf6";
              workspace = spaces."Entertainment".id;
              url = "https://youtube.com";
              position = 102;
              isEssential = false;
            };
            "Notion" = {
              id = "48e8a119-5a14-7890-9545-91c8e8dd3bf7";
              workspace = spaces."School".id;
              url = "https://www.notion.so/";
              position = 103;
              isEssential = false;
            };
            "Smartschool" = {
              id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
              workspace = spaces."School".id;
              url = "https://tandem.smartschool.be/";
              isEssential = false;
              position = 104;
            };
            "Pelckmans" = {
              id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a178";
              workspace = spaces."School".id;
              url = "https://www.pelckmansportaal.be/";
              isEssential = false;
              position = 105;
            };
          };

          containersForce = true;
          containers = {
            Shopping = {
              color = "yellow";
              icon = "dollar";
              id = 2;
            };
          };

          spacesForce = true;
          spaces = {
            "Personal" = {
              id = "c6de089c-410d-4206-961d-ab11f988d40a";
              icon = "🏠";
              position = 1000;
              theme = {
                type = "gradient";
                colors = [
                  {
                    red = 216;
                    green = 204;
                    blue = 235;
                    algorithm = "floating";
                    type = "explicit-lightness";
                  }
                ];
                opacity = 0.8;
                texture = 0.5;
              };
            };
            "School" = {
              id = "cdd10fab-4fc5-494b-9041-325e5759195b";
              icon = "🎓";
              position = 2000;
              theme = {
                type = "gradient";
                colors = [
                  {
                    red = 171;
                    green = 219;
                    blue = 227;
                    algorithm = "floating";
                    type = "explicit-lightness";
                  }
                ];
                opacity = 0.2;
                texture = 0.5;
              };
            };
            "Entertainment" = {
              id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc25";
              icon = "🎮";
              position = 3000;
            };
            "Shopping" = {
              id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
              icon = "💸";
              container = containers."Shopping".id;
              position = 4000;
            };

          };

          search = {
            force = true;
            default = "ddg";
            engines =
              let
                nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              in
              {
                "Nix Packages" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "channel";
                          value = "unstable";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = nixSnowflakeIcon;
                  definedAliases = [ "np" ];
                };
                "Nix Options" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
                      params = [
                        {
                          name = "channel";
                          value = "unstable";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = nixSnowflakeIcon;
                  definedAliases = [ "nop" ];
                };
                "Home Manager Options" = {
                  urls = [
                    {
                      template = "https://home-manager-options.extranix.com/";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "release";
                          value = "master"; # unstable
                        }
                      ];
                    }
                  ];
                  icon = nixSnowflakeIcon;
                  definedAliases = [ "hmop" ];
                };
                bing.metaData.hidden = "true";
              };
          };
        };
      };
    };
  };
}
