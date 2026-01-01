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

    home.extraOptions = {
      programs.ssh = {
        enable = true;
        # extraConfig = ''
        #   # Personal github account
        #   Host github.com
        #   HostName github.com
        #   PreferredAuthentications publickey
        #   IdentityFile ~/.ssh/github
        # '';
      };


      home.packages = with pkgs; [ 
        # NOTE install unstable packages by typing: unstable.<packageName>
        shellcheck # NOTE to check shell scripts (+ andere programmeertalen?) in vscode
        unstable.devenv
      ];
    };
  };
}
