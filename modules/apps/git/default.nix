{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.apps.git;
in 
{
  options.apps.git = {
    enable = lib.mkEnableOption "Enable and configure git";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      programs.git = {
        enable = true;

        settings = {
          user.name = "Nebilam";
          user.email = "49345234+Nebilam@users.noreply.github.com";

          # TODO setup signing so commits are verified on github
          core.editor = "nvim";
          pull.rebase = "true";
          push.autoSetupRemote = true;
          init.defaultBranch = "main";
          status.showStash = true;
          # mergetool.keepBackup = false; # TODO what does this?
        };

        # includes = [
        #     { path = "~/.gitconfig"; }
        #   ];
      };

      programs.difftastic = {
        enable = true;
        git.enable = true;
      };
    };
  };
}
