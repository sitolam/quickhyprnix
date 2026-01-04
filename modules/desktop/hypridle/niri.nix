{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.desktop.niri.hypridle;
in
{
  options.desktop.niri.hypridle = {
    enable = lib.mkEnableOption "Enable hypridle";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "noctalia-shell ipc call lockScreen lock";
            before_sleep_cmd = "noctalia-shell ipc call lockScreen lock";
          };

          listener = [
            {
              timeout = 240;
              on-timeout = "noctalia-shell ipc call lockScreen lock";
            }
            {
              timeout = 300;
              on-timeout = "niri msg action power-off-monitors";
              on-resume = "niri msg action power-on-monitors";
            }
            {
              timeout = 600;
              on-timeout = "noctalia-shell ipc call sessionMenu lockAndSuspend";
            }
          ];
        };
      };
    };
  };
}
