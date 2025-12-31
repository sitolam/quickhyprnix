{
  # options,
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.apps.zsh;
in 
{
  options.apps.zsh = {
    enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf cfg.enable {
    # TODO look add https://carapace.sh/ (betere auto complete)
    home.extraOptions = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion = {
          enable = true;
          # strategy = [
          #   "completion"
          # ];
        };    
        oh-my-zsh = {
          enable = true; # to get autocompletion for dir like in fish
        };
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "vi-mode";
            src = pkgs.zsh-vi-mode;
            file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
        ];

        initContent = ''
          # Load zsh-vi-mode first before other plugins
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
          
          # Configure vi mode
          ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
          ZVM_VI_INSERT_ESCAPE_BINDKEY='^['  # Explicitly bind ESC key
          
          # Ensure vi-mode doesn't get overridden
          function zvm_after_init() {
            [ -f ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh ] && \
              source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
          }

          export PATH=$HOME/.local/bin:$PATH

          eval "$(oh-my-posh init zsh)" # enable oh-my-posh
        '';
      };
    };

    programs.zsh.enable = true; # enable zsh for all users
    users.defaultUserShell = pkgs.zsh;
  };
}