{
  options,
  config,
  pkgs,
  lib,
  ...
}:

# TODO look if I need to improve this
let
  cfg = config.hardware.nvidia;
in
{
  options.hardware.nvidia = {
    enable = lib.mkEnableOption "Enable drivers and patches for Nvidia hardware.";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = true;

    # hardware.nvidia.package = let
    #   rcu_patch = pkgs.fetchpatch {
    #     url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
    #     hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
    #   };
    # in
    #   config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #     version = "535.154.05";
    #     sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
    #     sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
    #     openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
    #     settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
    #     persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";

    #     patches = [rcu_patch];
    #   };

    environment.variables = {
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      NIXOS_OZONE_WL = "1"; # NOTE hint electron apps to use wayland
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_VRR_ALLOWED = "0";
    };
    environment.shellAliases = {
      nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";
    };

    # Apply CachyOS kernel 6.19 patch to NVIDIA latest driver
    hardware.nvidia.package =
      let
        base = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "590.48.01";
          sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
          openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
          settingsSha256 = "sha256-4SfCWp3swUp+x+4cuIZ7SA5H7/NoizqgPJ6S9fm90fA=";
          persistencedSha256 = "";
        };
        cachyos-nvidia-patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
          sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
        };

        # Patch the appropriate driver based on config.hardware.nvidia.open
        driverAttr = if config.hardware.nvidia.open then "open" else "bin";
      in
      base
      // {
        ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
        });
      };
    hardware.nvidia.powerManagement.enable = true; # FIXME does this solve the problem with suspend, what does this excatly do?

    # Hyprland settings
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.

    hardware.graphics = {
      enable = true;
      # driSupport = true;
      # driSupport32 = true;
    };
  };
}
