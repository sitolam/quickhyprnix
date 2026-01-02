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
  cfg = config.desktop.illogical-impulse;
in
{

  options.desktop = {
    illogical-impulse = {
      enable = lib.mkEnableOption "Enable illogical-impulse";
    };
  };

  config = lib.mkIf cfg.enable {

    # Enable Hyprland
    programs.hyprland.enable = true;

    # Required services
    services.geoclue2.enable = true; # For QtPositioning
    # services.networkmanager.enable = true;  # For network management

    # System fonts (optional but recommended)
    fonts.packages = with pkgs; [
      rubik
      nerd-fonts.ubuntu
      nerd-fonts.jetbrains-mono
    ];

    home.extraOptions = {
      imports = [
        inputs.illogical-flake.homeManagerModules.default
      ];
      programs.illogical-impulse.enable = true;
    };

  };
}
