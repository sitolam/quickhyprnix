{
  # options,
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.apps.fish;
in
{
  options.apps.fish = {
    enable = lib.mkEnableOption "Enable fish";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
          fish_vi_key_bindings # TODO search online how this actually works
        '';
        shellInit = "starship init fish | source\n direnv hook fish | source";

        shellAbbrs = {
          ns = "nix-shell --command fish -p";

          gst = "git status";
          gl = "git log --graph --all --oneline";
          gln = "git log --oneline origin/HEAD..HEAD"; # log for everything new on this branch compared to main
          gll = "git log -p --ext-diff --graph --all"; # git log long (with external diff tool)
          gd = "git diff";
          gds = "git diff --staged";
          gdo = "git diff --no-ext-diff"; # original git diff (no external diff tool)
        };

        plugins = [
          # TODO look at fish plugins: https://nixos.wiki/wiki/Fish
        ];
      };
    };
    environment.shells = with pkgs; [ fish ];

    users.users.${username} = {
      shell = pkgs.fish;
      ignoreShellProgramCheck = true; # FIXME why is the shell not working without this?
    };

  };
}
