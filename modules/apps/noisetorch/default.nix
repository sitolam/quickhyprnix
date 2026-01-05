{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.noisetorch;
in
{
  options.apps.noisetorch = {
    enable = lib.mkEnableOption "Enable noisetorch";
  };

  config = lib.mkIf cfg.enable {
    programs.noisetorch = {
      enable = true;
    };
  };
}
