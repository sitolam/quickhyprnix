{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.suites.media;
in
{
  options.suites.media = {
    enable = lib.mkEnableOption "Enable the media suit";
  };

  config = lib.mkIf cfg.enable {
    apps.obs.enable = true;
    apps.spotify.enable = true;
    apps.gpu-screen-recorder.enable = true;
    apps.droidcam.enable = true;
    apps.noisetorch.enable = true;
    home.extraOptions = {
      home.packages = with pkgs; [
        gimp
        inkscape
        kdePackages.kdenlive

        # Video
        mpv
        vlc
        clapper
        losslesscut-bin

        # Image
        loupe

        handbrake

        cava # Audio visualizer

      ];
    };
  };
}
