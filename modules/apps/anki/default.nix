{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.anki;
in
{
  options.apps.anki = {
    enable = lib.mkEnableOption "Enable anki";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions.home.packages = with pkgs; [ anki-bin ];
    #TODO maybe with this option and addons here (not with syncthing), maybe disable stylix theming but custom theming with recolor

    # home.extraOptions.programs.anki = {
    #   enable = true;
    # };

  };
}
