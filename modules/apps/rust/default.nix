{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.rust;
in 
{
  options.apps.rust = {
    enable = lib.mkEnableOption "Enable the rust programming language";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      home.packages = with pkgs; [ 
        rustup
        gcc
        gnumake
      ];

      home.sessionPath = [ "$HOME/.cargo/bin" ]; # to be able to run commands like espup

    };
  };
}
