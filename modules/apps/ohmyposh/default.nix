{
  # options,
  config,
  lib,
  username,
  ...
}:

let
  cfg = config.apps.ohmyposh;
in 
{
  options.apps.ohmyposh = {
    enable = lib.mkEnableOption "Enable oh-my-posh (custom prompt)";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = { 
      programs.oh-my-posh = {
        enable = true;
        # package = pkgs.oh-my-posh; # TODO nodig?
        # enableFishIntegration = true;
        enableZshIntegration = true; # TODO aanzetten

        # NOTE example config (.toml): https://github.com/dreamsofcode-io/dotfiles/blob/a3da2687f7a9ef575c3a54042c4cc3a7b066f04f/.config/ohmyposh/zen.toml#L4
        # NOTE example config (.nix): https://github.com/LuminarLeaf/arboretum/blob/main/modules/user/shell/tools/omp.nix
        settings = {
          # TODO nog testen
          # TODO toevoegen nix shell: https://github.com/LuminarLeaf/arboretum/blob/main/modules/user/shell/tools/omp.nix
          # TODO palette kleuren toevoegen?: https://github.com/LuminarLeaf/arboretum/blob/7e7a32659a1cb449ee7120c77457b01cb4dcd904/modules/user/shell/tools/omp.nix#L120 
          version = 2;
          final_space = true;
          console_title_template = "{{ .Shell }} in {{ .Folder }}";
          
          blocks = [
            {
              type = "prompt";
              alignment = "left";
              newline = true;
              segments = [
                {
                  type = "path";
                  style = "plain";
                  background = "transparent";
                  foreground = "blue";
                  template = "{{ .Path }}";
                  properties = {
                    style = "full";
                  };
                }
                {
                  type = "git";
                  style = "plain";
                  foreground = "p:grey";
                  background = "transparent";
                  template = " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>";
                  properties = {
                    branch_icon = "";
                    commit_icon = "@";
                    fetch_status = true;
                  };
                }
              ];
            }
            {
              type = "rprompt";
              overflow = "hidden";
              segments = [
                {
                  type = "executiontime";
                  style = "plain";
                  foreground = "yellow";
                  background = "transparent";
                  template = "{{ .FormattedMs }}";
                  properties = {
                    threshold = 5000;
                    style = "round";
                  };
                }
                {
                  # TODO status nog wat customizen
                  type = "status";
                  # style = "plain"; # 
                  foreground = "red";
                  # background = "transparent";
                  # properties = {
                  # };
                }
              ];
            }
            {
              type = "prompt";
              alignment = "left";
              newline = true;
              segments = [
                {
                  type = "text";
                  style = "plain";
                  foreground_templates = [
                    "{{if gt .Code 0}}red{{end}}"
                    "{{if eq .Code 0}}magenta{{end}}"
                  ];
                  background = "transparent";
                  template = "❯";
                }
              ];
            }
          ];

          secondary_prompt = {
            foreground = "magenta";
            background = "transparent";
            template = "❯❯ ";
          };

        };
      }; 
    };
  };
}
