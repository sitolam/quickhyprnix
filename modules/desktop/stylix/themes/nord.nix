# theming/themes/nord.nix
{ }:
{
  themeName = "nord";
  polarity = "dark";

  wallpaper = ../../../../non-nix/wallpapers/nord.png;

  override = {
    base02 = "#445060";
    base05 = "#fffcf0";
  };

  btopTheme = "nord";
}
