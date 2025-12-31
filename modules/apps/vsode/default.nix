{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.vscode;
in 
{
  options.apps.vscode = {
    enable = lib.mkEnableOption "Enable vscode";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.vscode = {
        enable = true;
        # package = pkgs.vscode.fhs;
        package = pkgs.unstable.vscode; # FIXME why does this not work without this (without this unfree error)
      };
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
