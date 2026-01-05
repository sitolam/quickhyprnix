{
  # options,
  config,
  inputs,
  lib,
  pkgs,
  isVm,
  isLaptop,
  ...
}:

let
  cfg = config.services.kde-connect;
in
{

  options.services = {
    kde-connect = {
      enable = lib.mkEnableOption "Enable kde-connect";
    };
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions.services.kdeconnect = {
      enable = true;
    };
    networking.firewall = {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
