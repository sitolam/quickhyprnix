{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.keyboard.kanata;
in 
{
  options.keyboard.kanata = {
    enable = lib.mkEnableOption "enable remapping of keys";
  };

  config = lib.mkIf cfg.enable {
    # home.extraOptions = {
    # };
    # LINK docs: https://github.com/jtroo/kanata/blob/main/docs/config.adoc
    # LINK better (short) docs: https://github.com/shombando/shom.dev/blob/778d9978ee4c887855ca1af2cddee8957486ba4b/start.org#L178
    # NOTE see which key are pressed: showkey -a
    services.kanata = {
      enable = true;
      keyboards = {
        # NOTE name keyboard (see options: https://mynixos.com/nixpkgs/options/services.kanata.keyboards.%3Cname%3E)
        default = {
          devices = [
            # NOTE all devices if empty
          ];
          extraDefCfg = ''
            log-layer-changes no
            process-unmapped-keys yes ;; nodig zodat bij caps-word alle letters captital + dan werk tap-hold beter
            concurrent-tap-hold yes
          '';
          config = builtins.readFile ./config.kbd;
        };
      };
    };
  };
}
