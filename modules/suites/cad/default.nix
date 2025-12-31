{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.suites.cad;
in 
{
  options.suites.cad = {
    enable = lib.mkEnableOption "Enable the cad suit";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      home.packages = with pkgs; [ 
          prusa-slicer
          openscad-unstable
      ];
    };
  };
}
