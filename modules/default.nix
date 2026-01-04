{
  imports = [
    ./home.nix

    ./hardware/nvidia
    ./hardware/intelgpu
    ./hardware/fingerprint

    ./nh
    ./kanata

    ./desktop/niri
    ./desktop/niri/plugins.nix
    ./desktop/hypridle
    ./desktop/stylix
    ./desktop/noctalia
    ./desktop/illogical-impulse

    ./suites/common
    ./suites/development
    ./suites/school
    ./suites/gaming

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
    ./apps/tmux
    ./apps/rust
    ./apps/vsode
    ./apps/anki
    ./apps/signal
    ./apps/gparted

    ./services/bluetooth.nix
  ];
}
