{
  options,
  config,
  pkgs,
  lib,
  ...
}:

# TODO look if I need to improve this
let
  cfg = config.hardware.fingerprint;
in
{
  options.hardware.fingerprint = {
    enable = lib.mkEnableOption "Enable drivers and patches for fingerprint hardware.";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fprintd = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
    };
    services.fprintd.enable = true;

  };
}
