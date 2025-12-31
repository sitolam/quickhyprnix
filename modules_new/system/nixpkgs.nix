{ config, lib, ... }:

{
  nixpkgs = {
      # You can add overlays here
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages
        # Add overlays exported from other flakes:
      ];
      # Configure your nixpkgs instance
      config = {
        allowUnfree = true;
        # allowUnfreePredicate = _: true;

      };
    };
}