{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

# FIXME add gtk theme env or stylix?
# FIXME gparted-fix not showing up in rofi

let
  cfg = config.apps.gparted;
  # gparted-fix = pkgs.writeShellScriptBin "gparted-fix" ''
  #   pkexec bash -c "ln -s /home/$USER/.themes /root; env GTK_THEME="${settings.GTK_THEME}" XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR WAYLAND_DISPLAY=$WAYLAND_DISPLAY ${pkgs.gparted}/bin/gparted"
  #   '';
  gparted-fix = pkgs.writeShellScriptBin "gparted-fix" ''
    pkexec bash -c "ln -s /home/$USER/.themes /root; env XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR WAYLAND_DISPLAY=$WAYLAND_DISPLAY ${pkgs.gparted}/bin/gparted"
  '';
in
{
  options.apps.gparted = {
    enable = lib.mkEnableOption "Enable the gparted";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      home.packages = with pkgs; [
        gparted
        gparted-fix
      ];

      xdg.desktopEntries.gparted = {
        name = "GParted";
        genericName = "Partition Editor";
        comment = "Create, reorganize, and delete partitions";
        exec = "gparted-fix";
        icon = "gparted";
        terminal = false;
        type = "Application";
        categories = [
          "GNOME"
          "System"
          "Filesystem"
        ];
      };
    };

  };
}
