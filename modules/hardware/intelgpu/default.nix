
{
  options,
  config,
  pkgs,
  lib,
  ...
}:

# TODO look if I need to improve this
let
  cfg = config.hardware.intelgpu;
in 
{
  options.hardware.intelgpu = {
    enable = lib.mkEnableOption "Enable drivers and patches for intelgpu hardware.";
  };

  config = lib.mkIf cfg.enable {
    # hardware.intelgpu.driver = "xe";

    environment.variables = {
      NIXOS_OZONE_WL = "1"; # NOTE hint electron apps to use wayland
    };

    # Hyprland settings
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vpl-gpu-rt
      ];
      # driSupport = true;
      # driSupport32 = true;
    };
  };
}