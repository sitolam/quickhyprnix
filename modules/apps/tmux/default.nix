{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.tmux;
in 
{
  options.apps.tmux = {
    enable = lib.mkEnableOption "Enable tmux";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.tmux = {  
        enable = true;
        extraConfig = "
          set -g allow-passthrough on
          set -ga update-environment TERM
          set -ga update-environment TERM_PROGRAM
        ";

      };
    };
  };
}
