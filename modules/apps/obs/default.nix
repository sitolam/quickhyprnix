{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.obs;
in
{
  options.apps.obs = {
    enable = lib.mkEnableOption "Enable obs";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions.programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
        obs-backgroundremoval
        input-overlay
        obs-move-transition
        obs-replay-source
        obs-websocket
      ];
    };
  };
}
