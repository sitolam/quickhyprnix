{
  pkgs,
  inputs,
  ...
}:

let
  brightnessScript = pkgs.writeShellScriptBin "brightness" ''
    BUS=10
    STEP=5
    MIN=0
    MAX=100
    OSD_FILE="/tmp/brightness_osd_level"

    current=$(ddcutil --bus=$BUS getvcp 10 | grep -oP "current value\\s*=\\s*\\K[0-9]+")
    new=$current

    if [[ "$1" == "up" ]]; then
      new=$((current + STEP))
      (( new > MAX )) && new=$MAX
    elif [[ "$1" == "down" ]]; then
      new=$((current - STEP))
      (( new < MIN )) && new=$MIN
    else
      exit 1
    fi

    ddcutil --bus=$BUS setvcp 10 "$new"
    echo "$new" > "$OSD_FILE"
  '';

  niriParseKeybinds = pkgs.writeShellScriptBin "niri-parse-keybinds" ''
    exec ${pkgs.python3}/bin/python \
      ${inputs.niri-tweaks}/niri_parse_keybinds.py "$@" | fuzzel -d -w 100 -f monospace --match-mode exact'';

in
{
  programs.fuzzel.enable = true;
  home.packages = [
    brightnessScript
    niriParseKeybinds
  ];
}
