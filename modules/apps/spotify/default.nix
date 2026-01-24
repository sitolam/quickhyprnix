{
  # options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with config.lib.stylix.colors;

#TODO maybe add spotify-cava script
#TODO add option to disable/enable spicetify

let
  cfg = config.apps.spotify;
in

{
  options.apps.spotify = {
    enable = lib.mkEnableOption "Enable spotify with spicetfy";
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions = {
      imports = [ inputs.spicetify-nix.homeManagerModules.default ];
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
      programs.spicetify =
        let
          spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          enable = true;

          enabledExtensions = with spicePkgs.extensions; [
            shuffle # shuffle+ (special characters are sanitized out of extension names)
            groupSession # Allows you to create a link to share with your friends to listen along with you.
            powerBar # Spotlight-like search bar for spotify.
            songStats # Show a song's stats, like dancability, tempo, and key.
            history # Adds a page that shows your listening history.
            skipOrPlayLikedSongs # Skips songs you have liked or play songs you haven't liked
            goToSong # Go to the currrently playing song in a playlist /or/ currently playing playlist.
            playlistIntersection # See songs in common between two playlists or songs only present in one playlist
            playNext # Add the option to context menu to add stuff(albums, tracks, playlists) to the top of the queue.
          ];

          enabledCustomApps = with spicePkgs.apps; [
            marketplace # Add a page where you can browse extensions, themes, apps, and snippets. Using the marketplace does not work with this flake, however it is still here in order to allow for browsing.
            localFiles # Add a shortcut to see just your local files.
            lyricsPlus # Add a page with pretty scrolling lyrics.
          ];

          theme = spicePkgs.themes.sleek;
          colorScheme = "custom";
          customColorScheme = {
            "text" = "${magenta}";
            "subtext" = "${base05}";
            "nav-active-text" = "${bright-green}";
            "main" = "${base00}";
            "sidebar" = "${base00}";
            "player" = "${base00}";
            "card" = "${base00}";
            "shadow" = "${base02}";
            "main-secondary" = "${base01}";
            "button" = "${orange}";
            "button-secondary" = "${bright-cyan}";
            "button-active" = "${orange}";
            "button-disabled" = "${base0D}";
            "nav-active" = "${magenta}";
            "play-button" = "${green}";
            "tab-active" = "${yellow}";
            "notification" = "${blue}";
            "notification-error" = "${red}";
            "playback-bar" = "${bright-green}";
            "misc" = "${bright-magenta}";
          };
        };
    };
  };
}
