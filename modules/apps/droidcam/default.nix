{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.droidcam;
in
{
  options.apps.droidcam = {
    enable = lib.mkEnableOption "Enable droidcam";
  };

  config = lib.mkIf cfg.enable {
    programs.droidcam.enable = true;

    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=4 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    security.polkit.enable = true;
  };
}
