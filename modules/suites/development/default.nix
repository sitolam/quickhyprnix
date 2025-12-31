{
  # options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.suites.development;
in 
{
  options.suites.development = {
    enable = lib.mkEnableOption "Enable the development suit";
  };

  config = lib.mkIf cfg.enable {
    apps.direnv.enable = true;
    apps.vscode.enable = true;
    apps.rust.enable = true;
    apps.c.enable = true;
    apps.db.enable = true;

    home.extraOptions = {
      programs.ssh = {
        enable = true;
        extraConfig = ''
          # Personal github account
          Host github.com
          HostName github.com
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/github

          # UGent github account
          Host github.ugent.be github.UGent.be
          HostName github.ugent.be
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/github-ugent

          # subgit
          Host subgit.ugent.be subgit.UGent.be
          HostName subgit.ugent.be
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/subgit

        '';
      };


      home.packages = with pkgs; [ 
        # NOTE install unstable packages by typing: unstable.<packageName>
        shellcheck # NOTE to check shell scripts (+ andere programmeertalen?) in vscode
        unstable.devenv
      ];
    };
  };
}
