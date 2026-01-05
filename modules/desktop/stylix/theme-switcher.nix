{ pkgs, lib, ... }:

let
  themeLib = import ./themes { inherit lib; };
  themeNames = builtins.attrNames themeLib.themes;

  switcher = pkgs.writeShellScriptBin "switch-theme" ''
    set -euo pipefail

    THEME_FILE="$HOME/.config/stylix/current-theme.nix"
    mkdir -p "$(dirname "$THEME_FILE")"

    THEME=$(printf "%s\n" ${lib.concatStringsSep " " themeNames} | fuzzel --dmenu)
    [ -z "$THEME" ] && exit 0

    cat > "$THEME_FILE" <<EOF
    {
      theming.stylix.theme = "$THEME";
    }
    EOF

    notify-send -u low "Stylix" "Switching to $THEME"

    alacritty -e bash -c "nh os switch /home/otis/quickhyprnix --impure"
    reload-noctalia #FIXME fix the hardcoded path and try to remove the alacritty terminal

  '';
in
{
  home.extraOptions.home.packages = [
    pkgs.fuzzel
    switcher
  ];
}
