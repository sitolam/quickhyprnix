{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.zoxide;
in
{
  options.apps.zoxide = {
    enable = lib.mkEnableOption "Enable zoxide";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = true; # NOTE this only works if bash is enabled with home-manager
      };
    };
  };
}
