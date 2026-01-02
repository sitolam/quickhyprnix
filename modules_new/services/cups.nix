{ config, lib, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
    # drivers = [ pkgs.hplipWithPlugin ];
  };
  # TODO configure printer

}
