# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # catppuccin-gtk = pkgs.callPackage ./catppuccin-gtk { };
  # gitkraken = pkgs.callPackage ./gitkraken { };

  # https://yildiz.dev/posts/packing-custom-fonts-for-nixos/
  # commodore-64-pixelized-font = pkgs.callPackage ./fonts/commodore-64-pixelized-font { };
}