{
  inputs,
  ...
}:

{
  # import the home manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # configure options
  programs.noctalia-shell = {
    enable = true;
    settings = {
      # configure noctalia here; defaults will
      # be deep merged with these attributes.
    };
    # this may also be a string or a path to a JSON file,
    # but in this case must include *all* settings.
  };
}
