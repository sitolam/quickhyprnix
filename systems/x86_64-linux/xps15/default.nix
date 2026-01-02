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
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc # FIXME nog eens bekijken, mss niet nodig (want zet iets uit met bluetooth?)
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware.nix

  ];

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # TODO declaratively set wifi networks (also edurom): https://nixos.wiki/wiki/Wpa_supplicant

  desktop.hyprland.monitors = {
    "DP-5" = {
      enabled = true;
      primary = true;
      width = 2560;
      height = 1440;
      refreshRate = 120.; # NOTE dock doesn't seem to support 144Hz (but monitor does)
      scale = 1.00;
    };
    "eDP-1" = {
      enabled = true;
      primary = false;
      width = 2880;
      height = 1800;
      refreshRate = 90.;
      x = 2560;
      y = 720;
      scale = 2.00;
    };
  };
  hardware.intelgpu.enable = true;
  hardware.fingerprint.enable = true;
  theming.stylix.enable = true;
  suites.common.enable = true;
  suites.development.enable = true;
  suites.school.enable = true;
  suites.gaming.enable = true; # TODO enabled houden?
  suites.cad.enable = true;
  apps.distrobox.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.onedrive.enable = true;
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # # This value determines the NixOS release from which the default
  # # settings for stateful data, like file locations and database versions
  # # on your system were taken. It‘s perfectly fine and recommended to leave
  # # this value at the release version of the first install of this system.
  # # Before changing this value read the documentation for this option
  # # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "23.05"; # Did you read the comment?

}
