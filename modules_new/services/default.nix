{ config, lib, ... }:

{

  imports = [

    ./cups.nix
    ./audio.nix

  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

}
