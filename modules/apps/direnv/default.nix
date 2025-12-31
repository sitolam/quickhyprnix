{
  # options,
  config,
  lib,
  ...
}:

let
  cfg = config.apps.direnv;
in 
{
  options.apps.direnv = {
    enable = lib.mkEnableOption "Enable direnv and nix-direnv";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
