{
  config,
  pkgs,
  inputs,
  lib,
  myLib,
  username,
  hostname,
  ...
}:
# added inputs (inputs from flake.nix for nixpkgs.url, home-manager)

{
  imports = [
    # TODO bekijken nixos-hardware
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc # FIXME nog eens bekijken, mss niet nodig (want zet iets uit met bluetooth?)
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware.nix

  ];

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # TODO declaratively set wifi networks (also edurom): https://nixos.wiki/wiki/Wpa_supplicant

  hardware.nvidia.enable = true;
  suites.common.enable = true;
  suites.development.enable = true;
  suites.media.enable = true;
  suites.school.enable = true;
  suites.social.enable = true;
  suites.gaming.enable = true;

}
