{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.apps.db;
in 
{
  options.apps.db = {
    enable = lib.mkEnableOption "Enable db tools";
  };

  config = lib.mkIf cfg.enable {
    apps.postgresql.enable = true;

    home.extraOptions = {
      home.packages = with pkgs; [ 
        jetbrains.datagrip
        dbeaver-bin
      ];

      # TODO IDEAvimrc?
      # FIXME staat dan 2 keer in bestand
      # home.file."/home/${username}/.ideavimrc".text = ''
      #   " Enable system clipboard integration
      #   set clipboard+=unnamed
      # '';

      home.file.".config/JetBrains/idea.vmoptions".text = ''
        -Dawt.toolkit.name=WLToolkit
      '';

      xdg.desktopEntries."datagrip-wl" = {
          name = "DataGrip (Wayland)";
          genericName = "SQL IDE";
          exec = "env DATAGRIP_VM_OPTIONS=.config/JetBrains/idea.vmoptions datagrip %u";
          terminal = false;
          type = "Application";
          categories = [ "Development" "IDE" ];
        };
    };
  };
}
