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

  reloadNoctalia = pkgs.writeShellScriptBin "reload-noctalia" ''
    # Ensure pkill and notify-send are available
    export PATH=${pkgs.procps}/bin:${pkgs.libnotify}/bin:$PATH

    # Kill and restart noctalia
    pkill quickshell || true
    nohup noctalia-shell >/dev/null 2>&1 &
  '';
in
{
  #TODO split up into multiple files
  #TODO automatically reload noctalia
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
      wtype
      gpu-screen-recorder
    ];
    services.udev.packages = [ pkgs.ddcutil ];
    users.users.${username}.extraGroups = [ " i2c" ];
    boot.kernelModules = [ "i2c-dev" ];

    environment.sessionVariables."NOCTALIA_SETTINGS_FALLBACK" =
      "/home/${username}/.config/noctalia/gui-settings.json";

    home.extraOptions = {
      home.packages = with pkgs; [
        reloadNoctalia
      ];

      imports = [
        inputs.noctalia.homeModules.default
        ./plugins.nix
      ];

      # configure options
      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
        settings = {
          general = {
            showSessionButtonsOnLockScreen = false;
            avatarImage = pkgs.copyPathToStore "${inputs.self}/non-nix/avatars/coolman.png";
            showScreenCorners = true;
            forceBlackScreenCorners = true;
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
                  id = "plugin:privacy-indicator";
                }
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
                  id = "Tray";
                }
                {
                  id = "plugin:timer";
                }
                {
                  id = "plugin:pomodoro";
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
          controlCenter = {
            shortcuts = {
              left = [
                {
                  id = "Network";
                }
                {
                  id = "Bluetooth";
                }
                {
                  id = "WallpaperSelector";
                }
                {
                  id = "plugin:screen-recorder";
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
            firstDayOfWeek = -1;
          };
          wallpaper = {
            directory = "${inputs.self}/non-nix/wallpapers";
            overviewEnabled = true;
          };
          appLauncher = {
            enableClipboardHistory = true;
            autoPasteClipboard = true;
          };
          notifications = {
            saveToHistory = {
              low = false;
            };
          };
          osd = {
            enabledTypes = [
              0
              1
              2
              null
              null
              null
              3
            ];
          };
          audio = {
            externalMixer = "pavucontrol";
            prefferedPlayer = "spotify";
          };
          network = {
            bluetoothRssiPollingEnabled = true;
          };
          brightness = {
            enableDdcSupport = true;
          };
          nightLight = {
            enabled = true;
          };
          systemMonitor = {
            enableDgpuMonitoring = true;
          };
          # configure noctalia here; defaults will
          # be deep merged with these attributes.
          # this may also be a string or a path to a JSON file,
          # but in this case must include *all* settings.
        };
      };
    };
  };
}
