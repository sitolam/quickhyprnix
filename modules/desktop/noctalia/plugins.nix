{ config, inputs, ... }:

{
  home.file.".config/noctalia/plugins" = {
    recursive = true;
    source = inputs.noctalia-plugins;
  };

  home.file.".config/noctalia/plugins/privacy-indicator/settings.json" = {
    text = builtins.toJSON {
      hideInactive = true;
      iconSpacing = 4;
      removeMargins = false;
    };
  };

  home.file.".config/noctalia/plugins.json" = {
    text = builtins.toJSON {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        privacy-indicator = {
          enabled = true;
        };
        kaomoji-provider = {
          enabled = true;
        };
        timer = {
          enabled = true;
        };
        screen-recorder = {
          enabled = true;
        };
      };
    };
  };
}
