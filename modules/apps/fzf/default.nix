{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.fzf;
in
{
  options.apps.fzf = {
    enable = lib.mkEnableOption "Enable fzf";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.fzf = {
        enable = true;
        enableFishIntegration = true; # NOTE  press CTRL + R to search history
        enableZshIntegration = true; # NOTE  press CTRL + R to search history
        enableBashIntegration = true; # NOTE  press CTRL + R to search history
      };
    };
  };
}
