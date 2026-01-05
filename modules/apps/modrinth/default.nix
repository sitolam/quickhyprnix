{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.modrinth;
in
{
  options.apps.modrinth = {
    enable = lib.mkEnableOption "Enable modrinth";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions =
      let
        modrinth-fix = pkgs.writeShellScriptBin "modrinth-fix" ''
          WEBKIT_DISABLE_DMABUF_RENDERER=1 LIBGL_ALWAYS_SOFTWARE=1 GDK_BACKEND=x11 ModrinthApp
        '';
      in
      {
        home.packages = with pkgs; [
          modrinth-app
          modrinth-fix
        ];

        xdg.desktopEntries.modrinth-app = {
          name = "Modrinth Fix";
          exec = "modrinth-fix";
          icon = "ModrinthApp";
          terminal = false;
          type = "Application";
          mimeType = [
            "application/x-modrinth-modpack+zip"
            "x-scheme-handler/modrinth"
          ];
          comment = "Modrinth's game launcher with wayland fix";
          startupNotify = true;
          categories = [
            "Game"
            "ActionGame"
            "AdventureGame"
            "Simulation"
          ];
        };
      };
  };
}
