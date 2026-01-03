{
  config,
  pkgs,
  ...
}:

let
  apps = import ./applications.nix { inherit pkgs; };

in
{
  programs.niri.settings.binds =
    with config.lib.niri.actions;
    let
      pactl = "${pkgs.pulseaudio}/bin/pactl";
      playerctl = "${pkgs.playerctl}/bin/playerctl";

      volume-up = spawn pactl [
        "set-sink-volume"
        "@DEFAULT_SINK@"
        "+5%"
      ];
      volume-down = spawn pactl [
        "set-sink-volume"
        "@DEFAULT_SINK@"
        "-5%"
      ];
      volume-mute = spawn pactl [
        "set-sink-mute"
        "@DEFAULT_SINK@"
        "toggle"
      ];
      media-play-pause = spawn playerctl [ "play-pause" ];
      media-next = spawn playerctl [ "next" ];
      media-previous = spawn playerctl [ "previous" ];
    in
    {
      #FIXME fix capitalisation
      #FIXME add comments
      # TODO add ocr
      # TODO add clipboard keybind

      # Quickshell Keybinds
      "super+Control+Return".action = spawn [
        "noctalia-shell"
        "ipc"
        "call"
        "launcher"
        "toggle"
      ];
      "super+Space".action = spawn [
        "noctalia-shell"
        "ipc"
        "call"
        "launcher"
        "toggle"
      ];
      "super+backspace".action = spawn [
        "noctalia-shell"
        "ipc"
        "call"
        "lockScreen"
        "lock"
      ];
      "super+shift+backspace".action = spawn [
        "noctalia-shell"
        "ipc"
        "call"
        "sessionMenu"
        "lockAndSuspend"
      ];
      "super+ctrl+backspace".action = spawn [
        "noctalia-shell"
        "ipc"
        "call"
        "sessionMenu"
        "toggle"
      ];

      # Niri keybinds

      "super+slash".action = spawn "niri-parse-keybinds";

      "xf86audioraisevolume".action = volume-up;
      "xf86audiolowervolume".action = volume-down;
      "xf86audiomute".action = volume-mute;
      "xf86audioplay".action = media-play-pause;
      "xf86audionext".action = media-next;
      "xf86audioprev".action = media-previous;

      "super+O".action = toggle-overview;
      "super+q".action = close-window;

      "super+Left".action = focus-column-left;
      "super+Right".action = focus-column-right;
      "super+Down".action = focus-window-down;
      "super+Up".action = focus-window-up;
      "super+H".action = focus-column-left;
      "super+L".action = focus-column-right;
      "super+J".action = focus-window-down;
      "super+K".action = focus-window-up;

      "super+Ctrl+Left".action = move-column-left;
      "super+Ctrl+Right".action = move-column-right;
      "super+Ctrl+Down".action = move-window-down;
      "super+Ctrl+Up".action = move-window-up;
      "super+Ctrl+H".action = move-column-left;
      "super+Ctrl+L".action = move-column-right;
      "super+Ctrl+J".action = move-window-down;
      "super+Ctrl+K".action = move-window-up;

      "super+Home".action = focus-column-first;
      "super+End".action = focus-column-last;
      "super+Ctrl+Home".action = move-column-to-first;
      "super+Ctrl+End".action = move-column-to-last;

      "super+Shift+Left".action = focus-monitor-left;
      "super+Shift+Down".action = focus-monitor-down;
      "super+Shift+Up".action = focus-monitor-up;
      "super+Shift+Right".action = focus-monitor-right;
      "super+Shift+H".action = focus-monitor-left;
      "super+Shift+J".action = focus-monitor-down;
      "super+Shift+K".action = focus-monitor-up;
      "super+Shift+L".action = focus-monitor-right;

      "super+Shift+Ctrl+Left".action = move-column-to-monitor-left;
      "super+Shift+Ctrl+Down".action = move-column-to-monitor-down;
      "super+Shift+Ctrl+Up".action = move-column-to-monitor-up;
      "super+Shift+Ctrl+Right".action = move-column-to-monitor-right;
      "super+Shift+Ctrl+H".action = move-column-to-monitor-left;
      "super+Shift+Ctrl+J".action = move-column-to-monitor-down;
      "super+Shift+Ctrl+K".action = move-column-to-monitor-up;
      "super+Shift+Ctrl+L".action = move-column-to-monitor-right;

      "super+Page_Down".action = focus-workspace-down;
      "super+Page_Up".action = focus-workspace-up;
      "super+U".action = focus-workspace-down;
      "super+I".action = focus-workspace-up;
      "super+Ctrl+Page_Down".action = move-column-to-workspace-down;
      "super+Ctrl+Page_Up".action = move-column-to-workspace-up;
      "super+Ctrl+U".action = move-column-to-workspace-down;
      "super+Ctrl+I".action = move-column-to-workspace-up;

      "super+Shift+Page_Down".action = move-workspace-down;
      "super+Shift+Page_Up".action = move-workspace-up;
      "super+Shift+U".action = move-workspace-down;
      "super+Shift+I".action = move-workspace-up;

      "super+WheelScrollDown" = {
        cooldown-ms = 150;
        action = focus-workspace-down;
      };
      "super+WheelScrollUp" = {
        cooldown-ms = 150;
        action = focus-workspace-up;
      };
      "super+Ctrl+WheelScrollDown" = {
        cooldown-ms = 150;
        action = move-column-to-workspace-down;
      };
      "super+Ctrl+WheelScrollUp" = {
        cooldown-ms = 150;
        action = move-column-to-workspace-up;
      };

      "super+WheelScrollRight" = {
        cooldown-ms = 150;
        action = focus-column-right;
      };
      "super+WheelScrollLeft" = {
        cooldown-ms = 150;
        action = focus-column-left;
      };
      "super+Ctrl+WheelScrollRight" = {
        cooldown-ms = 150;
        action = move-column-right;
      };
      "super+Ctrl+WheelScrollLeft" = {
        cooldown-ms = 150;
        action = move-column-left;
      };

      "super+Shift+WheelScrollDown" = {
        cooldown-ms = 150;
        action = focus-column-right;
      };
      "super+Shift+WheelScrollUp" = {
        cooldown-ms = 150;
        action = focus-column-left;
      };
      "super+Ctrl+Shift+WheelScrollDown" = {
        cooldown-ms = 150;
        action = move-column-right;
      };
      "super+Ctrl+Shift+WheelScrollUp" = {
        cooldown-ms = 150;
        action = move-column-left;
      };

      "super+1".action = focus-workspace 1;
      "super+2".action = focus-workspace 2;
      "super+3".action = focus-workspace 3;
      "super+4".action = focus-workspace 4;
      "super+5".action = focus-workspace 5;
      "super+6".action = focus-workspace 6;
      "super+7".action = focus-workspace 7;
      "super+8".action = focus-workspace 8;
      "super+9".action = focus-workspace 9;

      "super+shift+1".action.move-column-to-workspace = 1;
      "super+shift+2".action.move-column-to-workspace = 2;
      "super+shift+3".action.move-column-to-workspace = 3;
      "super+shift+4".action.move-column-to-workspace = 4;
      "super+shift+5".action.move-column-to-workspace = 5;
      "super+shift+6".action.move-column-to-workspace = 6;
      "super+shift+7".action.move-column-to-workspace = 7;
      "super+shift+8".action.move-column-to-workspace = 8;
      "super+shift+9".action.move-column-to-workspace = 9;

      "super+BracketLeft".action = consume-or-expel-window-left;
      "super+BracketRight".action = consume-or-expel-window-right;

      "super+comma".action = consume-window-into-column;
      "super+period".action = expel-window-from-column;

      "super+R".action = switch-preset-column-width;
      "super+shift+R".action = switch-preset-window-height;
      "super+ctrl+R".action = reset-window-height;
      "super+F".action = maximize-column;
      "super+Shift+F".action = fullscreen-window;

      "super+Ctrl+F".action = expand-column-to-available-width;

      "super+C".action = center-column;

      "super+Ctrl+C".action = center-visible-columns;

      "super+Minus".action = set-window-width "-10%";
      "super+Equal".action = set-window-width "+10%";

      "super+shift+Minus".action = set-window-height "-10%";
      "super+shift+Equal".action = set-window-height "+10%";

      "super+V".action = toggle-window-floating;
      "super+shift+V".action = switch-focus-between-floating-and-tiling;
      "super+Ctrl+space".action = spawn [
        "nsticky"
        "sticky"
        "toggle-active"
      ];

      "super+W".action = toggle-column-tabbed-display;

      "super+S".action.screenshot = [ ];
      "ctrl+Print".action.screenshot-screen = [ ];
      "alt+Print".action.screenshot-window = [ ];

      "super+Escape" = {
        allow-inhibiting = false;
        action = toggle-keyboard-shortcuts-inhibit;
      }; # FIXME not working

      "super+shift+E".action = quit;
      "ctrl+alt+delete".action = quit;

      "super+shift+P".action = power-off-monitors;

      # apps
      "super+t" = {
        hotkey-overlay.title = "Open a terminal";
        action = spawn apps.terminal;
      };
      "super+b".action = spawn apps.browser;
      # "super+t".action = spawn apps.terminal;
      #    "super+Space".action = spawn apps.appLauncher;
      "super+E".action = spawn apps.fileManager;

      # Tested with ghostty and kitty
      # "super+m".action = spawn apps.terminal [
      #   "--title=spotify_player"
      #   "-e"
      #   "spotify_player"
      # ];

    };
}
