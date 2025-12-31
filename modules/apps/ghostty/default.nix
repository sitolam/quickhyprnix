{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.ghostty;
in 
{
  options.apps.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.ghostty = {
        enable = true;
        # TODO configure settings
        # settings = {
        #   font.normal = {
        #     family = "MesloLGS Nerd Font Mono";
        #     style = "regular";
        #   };
        # };
        enableZshIntegration = true;
      };
    };
  };
}
