{
  # options,
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.system.nh;

  update = pkgs.writeShellScriptBin "update" ''
    env NH_FLAKE="$NH_FLAKE"
    clear
    nh os switch --impure
    if [ $? -ne 0 ]; then
        notify-send "Error" "Failed to switch NixOS configuration."
    else
        reload-noctalia
    fi
    read -n 1 -p 'Press any key to continue...'
  '';
in
{
  options.system.nh = {
    # NOTE see https://www.youtube.com/watch?v=DnA4xNTrrqY + https://github.com/viperML/nh
    enable = lib.mkEnableOption "Enable nixos helper (nh)";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.nh = {
        enable = true;
        flake = "/home/${username}/quickhyprnix"; # TODO make dynamic
        # NOTE  set location of flake config (so you don't have to type it every time you rebuild)
        clean.enable = true;
        clean.extraArgs = "--keep-since 30d --keep 5"; # TODO nog eens bekijken
      };
    };
    home.extraOptions.home.packages = with pkgs; [
      update
    ];
  };
}
