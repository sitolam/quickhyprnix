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
  nsticky = config.desktop.niri.plugins.nsticky;
in
{

  options.desktop.niri.plugins = {
    nsticky = {
      enable = lib.mkEnableOption "Enable nsticky plugin for Niri";
    };
  };

  config = lib.mkIf nsticky.enable {
    environment.systemPackages = [ inputs.nsticky.packages.${pkgs.stdenv.hostPlatform.system}.nsticky ];
    home.extraOptions.programs.niri.settings.spawn-at-startup = [ { command = [ "nsticky" ]; } ];

  };
}
