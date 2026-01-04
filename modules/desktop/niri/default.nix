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
  imports = [
    inputs.niri.nixosModules.niri
  ];

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
    home.extraOptions = {
      imports = [
        ./settings.nix # Your custom configuration files for Niri
        ./keybinds.nix
        ./rules.nix
        ./autostart.nix
        ./scripts.nix
      ];
    };
    # Various services to run when using niri (KDE module includes these when using Plasma)
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
      libinput.enable = true;
      fwupd.enable = true;
      accounts-daemon.enable = true;
      gvfs.enable = true; # usb device mounting
    };
    desktop.noctalia.enable = true;
    desktop.niri.plugins.nsticky.enable = true;
    desktop.niri.hypridle.enable = true;

  };
}
