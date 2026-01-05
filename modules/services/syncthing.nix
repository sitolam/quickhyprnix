{
  # options,
  config,
  inputs,
  lib,
  pkgs,
  isVm,
  isLaptop,
  username,
  ...
}:

let
  cfg = config.services._syncthing;
in
{

  options.services = {
    _syncthing = {
      enable = lib.mkEnableOption "Enable syncthing";
    };
  };

  config = lib.mkIf cfg.enable {
    # Syncthing dashboard is available at http://localhost:8384

    home.extraOptions = {
      services = {
        syncthing = {
          enable = true;
          overrideDevices = true; # overrides any devices added or deleted through the WebUI
          overrideFolders = true; # overrides any folders added or deleted through the WebUI
          settings = {
            devices = {
              "laxoi-server" = {
                id = "X2FLYN6-4XQI6MH-U7V5LNB-PMRVO54-BPDUMA2-AYSMXJO-42D5NYI-RVA3YAH"; # TODO make this a secret
              };
            };
            folders = {
              "anki-addons" = {
                path = "/home/${username}/.local/share/Anki2/addons21";
                devices = [
                  "laxoi-server"
                ];
              };
            };
          };
        };
      };
    };
  };
}
