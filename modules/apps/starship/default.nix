{
  # options,
  config,
  lib,
  username,
  ...
}:

let
  cfg = config.apps.starship;
in
{
  options.apps.starship = {
    enable = lib.mkEnableOption "Enable starship";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.starship = {
        enable = true;
      };
      home.file = {
        # Configuration written to ~/.config/starship.toml
        "/home/${username}/.config/starship.toml".text = builtins.readFile ./starship.toml;
      };
    };
  };
}
