{
  # options,
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.apps.scrcpy;

  scrcpy-screen = pkgs.writeShellScriptBin "screen" ''
    setsid scrcpy --shortcut-mod=lctrl --show-touches >/dev/null 2>&1 < /dev/null &
  '';
in
{
  options.apps.scrcpy = {
    enable = lib.mkEnableOption "Enable scrcpy";
  };

  config = lib.mkIf cfg.enable {
    # Android Debug Bridge (adb)
    programs.adb.enable = true;
    users.users.${username}.extraGroups = [ "adbusers" ];

    # Scrcpy
    environment.systemPackages = with pkgs; [
      qtscrcpy
      scrcpy
    ];

    home.extraOptions.home.packages = with pkgs; [
      scrcpy-screen
    ];

    systemd.services.scrcpy-camera = {
      description = "Persistent scrcpy front-camera capture to v4l2 loopback";
      after = [ "network.target" ]; # optional
      wants = [ "network.target" ]; # optional

      serviceConfig = {
        ExecStart = "${pkgs.scrcpy}/bin/scrcpy --video-source=camera --camera-facing=front --no-audio --v4l2-sink=/dev/video1 --no-video-playback --no-window --capture-orientation=270";

        Restart = "always";
        RestartSec = "2s";
        # Prevent systemd from killing it early
        TimeoutStartSec = "30s";
        TimeoutStopSec = "5s";

        # Runs in simple mode so ExecStart runs directly and stays attached
        Type = "simple";
      };

      enable = true;
    };
  };
}
