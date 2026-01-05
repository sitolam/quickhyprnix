{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.suites.social;
in
{
  options.suites.social = {
    enable = lib.mkEnableOption "Enable the social suit";
  };

  config = lib.mkIf cfg.enable {
    apps.signal.enable = true;
    home.extraOptions = {
      home.packages = with pkgs; [
        (discord.override {
          withVencord = true;
        }) # TODO add option to enable/disable vencord
        # TODO make vencord delclaritive
        element-desktop
        telegram-desktop
      ];
    };
  };
}
