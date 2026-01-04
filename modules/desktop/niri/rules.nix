{
  ...
}:

{
  programs.niri.settings = {
    layer-rules = [
      {
        matches = [
          {
            namespace = "^quickshell-wallpaper$";
          }
        ];
        #place-within-backdrop = true;
      }
      # {
      #   matches = [
      #     {
      #       namespace = "^quickshell-overview$";
      #     }
      #   ];
      #   place-within-backdrop = true;
      # }
      {
        matches = [
          {
            namespace = "^swww-daemon$";
          }
        ];
        place-within-backdrop = true;
      }
      {
        matches = [
          {
            namespace = "^noctalia-lockscreen*";
          }
        ];
        place-within-backdrop = true;
      }
    ];

    window-rules = [
      {
        matches = [ { is-focused = false; } ];
        opacity = 0.9;
      }
      {
        matches = [
          {
            app-id = "firefox";
            title = "Picture-in-Picture";
          }
          { app-id = "mpv"; }
          {
            app-id = "steam";
            title = "Friends List";
          }
          {
            app-id = "steam";
            title = "Steam Settings";
          }
          {
            app-id = "jetbrains.*";
            title = "Open File or Project";
          }
          {
            app-id = "jetbrains.*";
            title = "Settings";
          }
          {
            app-id = "jetbrains.*";
            title = "Confirm Exit";
          }
          {
            app-id = "jetbrains.*";
            title = "Update Project";
          }
          {
            app-id = "zoom";
            title = "Zoom Workplace";
          }
          {
            app-id = "zoom";
            title = "Settings";
          }
          {
            app-id = "zoom";
            title = "zoom";
          }
          {
            app-id = "swayimg";
          }
          {
            title = "Ouvrir.*";
          }
          {
            title = "Extension.*";
          }
          {
            title = "Enregistrer.*";
          }
          {
            title = "Add.*";
          }
        ];
        open-floating = true;
      }
      {
        matches = [
          { app-id = "org.keepassxc.KeePassXC"; }
        ];
        block-out-from = "screen-capture";
      }
      {
        matches = [
          { app-id = "mpd-picker"; }
          { app-id = "real-book-picker"; }
        ];
        open-floating = true;
        default-floating-position = {
          x = 0;
          y = 0;
          relative-to = "top";
        };
        default-window-height = {
          proportion = 0.3;
        };
        default-column-width = {
          proportion = 0.4;
        };
      }
      {
        matches = [ ];
        geometry-corner-radius = {
          bottom-left = 12.0;
          bottom-right = 12.0;
          top-left = 12.0;
          top-right = 12.0;
        };
        clip-to-geometry = true;
      }
    ];
  };
}
