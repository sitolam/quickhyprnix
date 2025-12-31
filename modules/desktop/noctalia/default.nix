{
  # options,
  config,
  lib,
  pkgs,
  isVm,
  isLaptop,
  inputs,
  ...
}:

let
  cfg = config.desktop.noctalia;
in
{
  imports = [
    # ./keybinds.nix
    # ./monitors.nix
  ];

  options.desktop = {
    noctalia = {
      enable = lib.mkEnableOption "Enable noctalia";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      # NOTE install unstable packages by typing: unstable.<packageName>
      inputs.noctalia.packages.${system}.default
    ];


  };
}