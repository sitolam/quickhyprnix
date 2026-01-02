{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  cfg = config.theming.stylix;
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.theming.stylix = {
    enable = lib.mkEnableOption "Enable stylix";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      stylix = {
        enable = true;
        polarity = "dark";
        image = ../../../non-nix/wallpapers/jellyfish.jpg;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        # override = {
        #   base02 = "#445060";
        #   base05 = "#fffcf0";
        # };
        opacity = {
          terminal = 0.6;
          applications = 0.6;
          desktop = 0.6;
        };

        iconTheme = {
          enable = true;
          dark = "WhiteSur";
          package = pkgs.whitesur-icon-theme;
        };

        targets.hyprlock.enable = false;
        targets.spicetify.enable = false;
        targets.vscode.enable = false;
        targets.starship.enable = false;
      };

    };

    # FIXME does stylix need to be enabled in the home module or nixos config?
    stylix = {
      enable = true;

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 5;
      };

      image = ../../../non-nix/wallpapers/jellyfish.jpg;

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
