{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.alacritty;
in 
{
  options.apps.alacritty = {
    enable = lib.mkEnableOption "Enable alacritty";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.alacritty = {
        enable = true;
        package = pkgs.unstable.alacritty-graphics;

        # TODO configure alacritty: https://home-manager-options.extranix.com/?query=alacr&release=release-24.05
        settings = {
          font.normal = {
            family = "MesloLGS Nerd Font Mono";
            style = "regular";
          };
        };
      };
    };
  };
}
