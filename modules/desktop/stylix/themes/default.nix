{ lib }:

let
  themes = {
    nord = import ./nord.nix { };
    catppuccin-mocha = import ./catppuccin-mocha.nix { };
  };
in
{
  #TODO switch themes with fuzzel script
  #TODO add random wallpaper functionality (also with option)

  inherit themes;

  get =
    name:
    if builtins.hasAttr name themes then
      themes.${name}
    else
      throw "Unknown theme: ${name} All available themes: ${lib.concatStringsSep ", " (lib.attrNames themes)}";
}
