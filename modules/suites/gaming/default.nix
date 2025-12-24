
{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.suites.gaming;
in 
{
  options.suites.gaming = {
    enable = lib.mkEnableOption "Enable the gaming suit";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      # TODO dit nodig?
      # gamescopeSession.extraOptions = {
      #   enable = true;
      #   extraArgs = "--enable-features=UseOzonePlatform";
      # };

      # TODO is dit beter?
      # extraCompatPackages = with pkgs; [
      #   proton-ge-bin
      # ];
    };

    programs.gamemode.enable = true; 

    home.extraOptions = {

      home.packages = with pkgs; [ 
        mangohud # TODO werk dit wel?
        protonup-qt
        prismlauncher
      ];

      home.sessionVariables = {
        steam_EXTRA_COMPAT_TOOLS_PATH = "\${HOME}/.steam/root/compatibilitytools.d"; 
      };

    };
  };
}
