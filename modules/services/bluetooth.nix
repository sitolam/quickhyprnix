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
  cfg = config.services.bluetooth;
in
{


  options.services = {
    bluetooth = {
      enable = lib.mkEnableOption "Enable bluetooth";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
        bluez
        bluez-tools
    ];

    hardware.bluetooth = {
        enable = true;
        package = pkgs.bluez;
    };
    services.blueman.enable = true;
  };
}