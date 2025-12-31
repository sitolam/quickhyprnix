{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.c;
in 
{
  options.apps.c = {
    enable = lib.mkEnableOption "Enable tools for the C and C++ programming language";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      home.packages = with pkgs; [ 
        gcc
        gnumake
        cmake

        gdb # debugging
        boost
      ];
    };
  };
}
