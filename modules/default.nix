{
  imports = [
    ./home.nix

    ./hardware/nvidia
    ./hardware/intelgpu
    ./hardware/fingerprint

    ./nh
    ./kanata
    ./stylix

    ./desktop/niri
    ./desktop/illogical-impulse

    ./suites/common
    ./suites/development
    ./suites/school
    ./suites/gaming
    ./suites/cad

    ./apps/distrobox
    ./apps/alacritty
    ./apps/ghostty
    ./apps/fish
    ./apps/zsh
    ./apps/starship
    ./apps/ohmyposh
    ./apps/git
    ./apps/direnv
    ./apps/fzf
    ./apps/zoxide
    ./apps/rust
    ./apps/vsode
    ./apps/anki
    ./apps/signal
    ./apps/intellij
    ./apps/gparted
    ./apps/postgresql

    ./services/bluetooth.nix
  ];
}
