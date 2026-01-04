{
  config,
  pkgs,
  lib,
  inputs,
  username,
  ...
}:

let
  localThemeFile = "/home/${username}/.config/stylix/current-theme.nix";
  defaultThemeFile = ./current-theme.nix;
  themeFile = if builtins.pathExists localThemeFile then localThemeFile else defaultThemeFile;

  cfg = config.theming.stylix;

  themeLib = import ./themes { inherit lib; };
  theme = themeLib.get (import themeFile).theming.stylix.theme;
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./theme-switcher.nix
  ];

  options.theming.stylix = {
    enable = lib.mkEnableOption "Enable stylix";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin-mocha";
      description = "The stylix theme to use from stylix/themes";
    };
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      stylix = {
        enable = true;
        polarity = theme.polarity or "dark";
        image = theme.wallpaper;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.themeName}.yaml";
        override = lib.mkIf (theme.override != null) theme.override;
        opacity = {
          terminal = 0.6;
          applications = 0.6;
          desktop = 0.95;
          popups = 0.95;
        };

        iconTheme = {
          enable = true;
          dark = "WhiteSur";
          package = pkgs.whitesur-icon-theme;
        };
        targets = {
          hyprlock.enable = false;
          spicetify.enable = false;
          vscode.enable = false;
          starship.enable = true;
          btop.enable = theme.btopTheme == null;
        };
      };

    };

    stylix = {
      enable = true;

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 7;
      };

      image = theme.wallpaper;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.themeName}.yaml";

      fonts = {
        # FIXME change this?
        monospace = {
          package = pkgs.nerd-fonts.meslo-lg;
          name = "MesloLGS Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sizes = {
          applications = 12;
          terminal = 15;
          desktop = 10;
          popups = 10;
        };
      };
      # targets.alacritty.enable = true;
      targets.console.enable = false;
      targets.plymouth.enable = false;
      targets.grub.enable = false;
      # stylix.targets.nixos-icons.enable = true;

    };
  };
}
