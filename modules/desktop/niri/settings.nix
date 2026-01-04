{
  pkgs,
  ...
}:

{
  #TODO: add blur
  #FIXME focus ring theming
  programs.niri = {
    settings = {
      prefer-no-csd = true;

      hotkey-overlay = {
        skip-at-startup = true;
      };

      input = {
        keyboard = {
          xkb = {
            layout = "us";
            variant = "intl";
            options = "compose::ralt";
          };
        };
        touchpad = {
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "10%";
        };
        warp-mouse-to-focus.enable = true;
        workspace-auto-back-and-forth = true;
      };
      cursor = {
        hide-after-inactive-ms = 5000;
      };

      outputs = {
        "DP-3" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.000;
          };
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
          focus-at-startup = true;
        };
        "HDMI-A-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.000;
          };
          scale = 1.0;
          position = {
            x = 1920;
            y = 0;
          };
        };
      };

      layout = {
        always-center-single-column = false;
        gaps = 16;
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 3.0 / 4.0; }
        ];
        # preset-window-heights = [
        #   { proportion = 1.0 / 4.0; }
        #   { proportion = 1.0 / 3.0; }
        #   { proportion = 1.0 / 2.0; }
        #   { proportion = 2.0 / 3.0; }
        # ];
      };

      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
        DISPLAY = ":0";
      };
    };
  };
}
