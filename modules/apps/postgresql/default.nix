{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.postgresql;
in 
{
  options.apps.postgresql = {
    enable = lib.mkEnableOption "Enable postgresql service (for server), postgresql tools (like psql) and pgadmin";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      home.packages = with pkgs; [ 
        pgadmin4-desktopmode
      ];
    };
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql; # NOTE otherwise an older version is installed
    };

    systemd.services.postgresql = {
      wantedBy = lib.mkForce [ ]; # makes sure service isn't started on boot
    };
  };
}
