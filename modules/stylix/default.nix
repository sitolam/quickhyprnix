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
        image = ../../non-nix/wallpapers/nord.png;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
        override = {
          base02 = "#445060";
          base05 = "#fffcf0";
        };
        opacity = {
            terminal = 0.6;
            applications = 0.6;
            desktop = 0.6;
        };

        # iconTheme = {
        #   enable = true;
        #   dark = settings.icons;
        #   light = settings.icons;
        #   package = settings.iconsPkg;
        # };

        targets.hyprlock.enable = false;
        targets.btop.enable = "nord";
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

      # base16Scheme = {
      #   base00 = "282828"; # ----
      #   base01 = "3c3836"; # ---
      #   base02 = "504945"; # --
      #   base03 = "665c54"; # -
      #   base04 = "bdae93"; # +
      #   base05 = "d5c4a1"; # ++
      #   base06 = "ebdbb2"; # +++
      #   base07 = "fbf1c7"; # ++++
      #   base08 = "fb4934"; # red
      #   base09 = "fe8019"; # orange
      #   base0A = "fabd2f"; # yellow
      #   base0B = "b8bb26"; # green
      #   base0C = "8ec07c"; # aqua/cyan
      #   base0D = "83a598"; # blue
      #   base0E = "d3869b"; # purple
      #   base0F = "d65d0e"; # brown
      # };

      # does not work >:(
      # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

      image = ../../non-nix/wallpapers/nord.png;

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
      # targets.plymouth.enable = true;
      # stylix.targets.nixos-icons.enable = true;

    };
  };
}