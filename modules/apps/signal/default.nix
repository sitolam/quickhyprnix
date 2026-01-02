{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.signal;
in
{
  options.apps.signal = {
    enable = lib.mkEnableOption "Enable signal";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      home.packages = with pkgs; [ signal-desktop ];
    };
    environment.variables = {
      # LANGUAGE = "en_US:nl_BE"; # NOTE to set spell checking language
      LANGUAGE = "en_US"; # NOTE to set spell checking language
    };
    # TODO autostart signal
  };
}
