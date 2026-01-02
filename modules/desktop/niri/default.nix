{
  # options,
  config,
  inputs,
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


  options.desktop = {
    niri = {
      enable = lib.mkEnableOption "Enable niri";
    };
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      imports = [
        inputs.niri.homeModules.niri # Import Niri's home-manager module
        ./settings.nix # Your custom configuration files for Niri
        ./keybinds.nix
        ./rules.nix
        ./autostart.nix
        ./scripts.nix
        ./applications.nix

        ./noctaliashell.nix
      ];
  };
  

  };
}