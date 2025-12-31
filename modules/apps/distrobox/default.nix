{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.distrobox;
in 
{
  options.apps.distrobox = {
    enable = lib.mkEnableOption "Enable distrobox";
  };

  config = lib.mkIf cfg.enable {

    home.extraOptions = {
      programs.distrobox = {
        enable = true;
        containers = {

          common-debian = {
            image = "debian:13";
                  # entry = true; # to add container as a app in app launcher
                  additional_packages = "";
                  # init_hooks = [
                  #   "ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/docker"
                  #   "ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/docker-compose"
                  # ];
          };

          arch-esp-rs = {
            image = "archlinux:latest";
                  additional_packages = "base-devel fastfetch rustup";
          };

        };
      };
    };
  };
}
