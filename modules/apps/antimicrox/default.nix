{
  # options,
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.apps.antimicrox;
in
{
  options.apps.antimicrox = {
    enable = lib.mkEnableOption "Enable antimicrox";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      home.packages = with pkgs; [
        antimicrox
      ];

      home.file.".config/antimicrox/antimicrox.gamecontroller.amgp" = {
        source = ./antimicrox.gamecontroller.amgp;
      };

      home.file.".config/antimicrox/antimicrox_settings.ini" = {
        text = ''
          [General]
          AutoOpenLastProfile=1
          CloseToTray=1
          LaunchInTray=1
          MinimizeToTaskbar=1

          [Controllers]
          Controller050018dc5e040000200b00002305000011182848ConfigFile1=/home/${username}/.config/antimicrox/antimicrox.gamecontroller.amgp
          Controller050018dc5e040000200b00002305000011182848LastSelected=/home/${username}/.config/antimicrox/antimicrox.gamecontroller.amgp

          [Notifications]
          notify_about_empty_battery=true
          notify_about_low_battery=true
        '';
      };
    };
  };
}
