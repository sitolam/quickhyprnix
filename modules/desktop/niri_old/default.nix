{
  # options,
  config,
  lib,
  pkgs,
  isVm,
  isLaptop,
  ...
}:

let
  cfg = config.desktop.niri;
in
{
  imports = [
    # ./keybinds.nix
    # ./monitors.nix
  ];

  options.desktop = {
    niri = {
      enable = lib.mkEnableOption "Enable niri";
    };
  };

  config = lib.mkIf cfg.enable {

    desktop.noctalia.enable = true;
    programs.niri.enable = true;


  };
}