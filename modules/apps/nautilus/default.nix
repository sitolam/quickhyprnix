{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.nautilus;
in
{
  options.apps.nautilus = {
    enable = lib.mkEnableOption "Enable nautilus";
  };

  config = lib.mkIf cfg.enable {
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };

    environment.systemPackages = with pkgs; [
      nautilus
    ];

    # needed for nautilus to manage files with elevated permissions
    security.polkit.enable = true;
    systemd.user.services.polkitAgent = {
      # TODO: move polkit somewhere common
      description = "Polkit GNOME Authentication Agent";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
      };
    };

    services.gvfs.enable = true;

  };
}
