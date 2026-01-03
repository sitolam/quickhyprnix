{
  # options,
  config,
  lib,
  pkgs,
  username,
  isVm,
  isLaptop,
  inputs,
  ...
}:

let
  cfg = config.desktop.noctalia;
in
{
  imports = [
    # ./keybinds.nix
    # ./monitors.nix
  ];

  options.desktop = {
    noctalia = {
      enable = lib.mkEnableOption "Enable noctalia";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ddcutil
      cliphist
      cava
      wlsunset
      xdg-desktop-portal
      pavucontrol
      libnotify
    ];
    services.udev.packages = [ pkgs.ddcutil ];
    users.users.${username}.extraGroups = [ " i2c" ];
    boot.kernelModules = [ "i2c-dev" ];

    environment.sessionVariables."NOCTALIA_SETTINGS_FALLBACK" =
      "/home/${username}/.config/noctalia/gui-settings.json";

    home.extraOptions = {
      home.packages = with pkgs; [

      ];

      imports = [
        inputs.noctalia.homeModules.default
      ];

      #FIXME: module settings

      # configure options
      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
        settings = {
          general = {
            showSessionButtonsOnLockScreen = false;
          };
          ui = {
            fontDefaultScale = 1.1;
            fontFixedScale = 1.1;
          };
          bar = {
            floating = false;
            widgets = {
              left = [
                {
                  icon = "rocket";
                  id = "CustomButton";
                  leftClickExec = "noctalia-shell ipc call launcher toggle";
                }
                {
                  id = "Clock";
                  usePrimaryColor = false;
                }
                {
                  id = "SystemMonitor";
                }
                {
                  id = "ActiveWindow";
                }
                {
                  id = "MediaMini";
                  showAlbumArt = true;
                  showArtistFirst = false;
                  showVisualizer = true;
                  visualizerType = "wave";
                }
              ];
              center = [
                {
                  id = "Workspace";
                }
              ];
              right = [
                {
                  id = "ScreenRecorder";
                }
                {
                  id = "Tray";
                }
                {
                  id = "NotificationHistory";
                }
                {
                  id = "Battery";
                }
                {
                  id = "Volume";
                }
                {
                  id = "Brightness";
                }
                {
                  id = "ControlCenter";
                }
              ];
            };
          };
          desktopWidgets = {
            enabled = true;
            gridSnap = true;
            monitorWidgets = [
              {
                name = "DP-3";
                widgets = [
                  {
                    hideMode = "hidden";
                    id = "MediaPlayer";
                    roudnedCorners = true;
                    scale = 1.5;
                    showAlbumArt = true;
                    showBackground = true;
                    showButtons = true;
                    showVisualizer = true;
                    visualizerType = "linear";
                    x = 1920 / 2 - 400 / 2 * 1.5; # TODO link to monitor resolution
                    y = 920;
                  }
                ];
              }
              {
                name = "HDMI-A-1";
                widgets = [
                  {
                    hideMode = "hidden";
                    id = "MediaPlayer";
                    roudnedCorners = true;
                    scale = 1.5;
                    showAlbumArt = true;
                    showBackground = true;
                    showButtons = true;
                    showVisualizer = true;
                    visualizerType = "linear";
                    x = 1920 / 2 - 400 / 2 * 1.5; # TODO link to monitor resolution
                    y = 920;
                  }
                ];
              }
            ];
          };

          location = {
            name = "Eeklo";
          };
          wallpaper = {
            directory = "${inputs.self}/non-nix/wallpapers";
          };
          appLauncher = {
            enableClipboardHistory = true;
          };
          notifications = {
            saveToHistory = {
              low = false;
            };
          };
          audio = {
            externalMixer = "pavucontrol";
          };
          brightness = {
            enableDdcSupport = true;
          };
          nightLight = {
            enabled = true;
          };
          # configure noctalia here; defaults will
          # be deep merged with these attributes.
        };
        # this may also be a string or a path to a JSON file,
        # but in this case must include *all* settings.
      };
    };
  };
}
