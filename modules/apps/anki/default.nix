{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.anki;
in 
{
  options.apps.anki = {
    enable = lib.mkEnableOption "Enable anki";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions.home.packages = with pkgs; [ anki-bin ];
    # home.extraOptions.programs.anki = {
    #   enable = true;
    # };
    # TODO add add-ons: https://www.phind.com/search?cache=j2jdufv9f9lrr1dnf6k54vbw
    # TODO other way to add add-ons?: https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/misc/markdown-anki-decks/default.nix
  };
}
