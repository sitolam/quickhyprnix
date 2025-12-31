{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.suites.school;
in 
{
  options.suites.school = {
    enable = lib.mkEnableOption "Enable the school suit";
  };

  config = lib.mkIf cfg.enable {
    apps.anki.enable = true;
    apps.intelij.enable = true;
    home.extraOptions = {
      home.packages = with pkgs; [ 
        obsidian
        flowtime

      ];
    };
  };
}
