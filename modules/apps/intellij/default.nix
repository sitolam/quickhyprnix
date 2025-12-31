{
  # options,
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.apps.intelij;
in 
{
  options.apps.intelij = {
    enable = lib.mkEnableOption "Enable intelij idea";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      home.packages = with pkgs; [ 
        jetbrains.idea-ultimate 

        jdk
        maven
        openjfx21
        glib
      ];

      home.file."/home/${username}/.ideavimrc".text = ''
        " Enable system clipboard integration
        set clipboard+=unnamed
      '';

      home.file.".config/JetBrains/idea.vmoptions".text = ''
        -Dawt.toolkit.name=WLToolkit
      '';

      xdg.desktopEntries."idea-ultimate-wl" = {
          name = "IntelliJ IDEA (Wayland)";
          genericName = "Java IDE";
          exec = "env IDEA_VM_OPTIONS=.config/JetBrains/idea.vmoptions idea-ultimate %u";
          terminal = false;
          type = "Application";
          categories = [ "Development" "IDE" ];
        };
    };

   
    # TODO check if this is needed
    environment.variables = {
      JAVA_HOME="${pkgs.jdk21}/lib/openjdk";
      PATH="$PATH:$JAVA_HOME/bin";
      JAVAFX_PATH="${pkgs.openjfx21}/lib";

      # PATH="$PATH:${pkgs.maven}/bin";
      LD_LIBRARY_PATH="${pkgs.libGL}/lib:${pkgs.gtk3}/lib:${pkgs.glib.out}/lib:${pkgs.xorg.libXtst}/lib:$LD_LIBRARY_PATH";
    };
  };
}
