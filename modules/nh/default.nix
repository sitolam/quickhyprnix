{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.system.nh;
in
{
  options.system.nh = {
    # NOTE see https://www.youtube.com/watch?v=DnA4xNTrrqY + https://github.com/viperML/nh
    enable = lib.mkEnableOption "Enable nixos helper (nh)";
  };

  config = lib.mkIf cfg.enable {
    # home.extraOptions = {
    programs.nh = {
      enable = true;
      flake = "/home/nebilam/Documents/GitHub/Nebix"; # NOTE  set location of flake config (so you don't have to type it every time you rebuild)
      clean.enable = true;
      clean.extraArgs = "--keep-since 30d --keep 5"; # TODO nog eens bekijken
    };
    # };
  };
}
