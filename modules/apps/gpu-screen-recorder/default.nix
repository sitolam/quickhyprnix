{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.gpu-screen-recorder;
in
{
  options.apps.gpu-screen-recorder = {
    enable = lib.mkEnableOption "Enable gpu-screen-recorder";
  };

  config = lib.mkIf cfg.enable {
    programs.gpu-screen-recorder.enable = true;

    environment.systemPackages = with pkgs; [
      unstable.gpu-screen-recorder-gtk
    ];
  };
}
