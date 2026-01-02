{
  # options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.suites.common;
in
{
  options.suites.common = {
    enable = lib.mkEnableOption "Enable the common suit";
  };

  config = lib.mkIf cfg.enable {
    desktop.niri.enable = true;
    desktop.illogical-impulse.enable = false;
    system.nh.enable = true;
    keyboard.kanata.enable = true; # NOTE remapping keyboard
    apps.alacritty.enable = true;
    apps.zsh.enable = true;
    apps.fish.enable = true;
    apps.starship.enable = true; # TODO maybe at one suite to enable system config (fish, startship, ...)
    apps.ohmyposh.enable = true;
    apps.git.enable = true;
    apps.fzf.enable = true;
    apps.zoxide.enable = true;
    apps.signal.enable = true;
    apps.gparted.enable = true;
    services.bluetooth.enable = true;
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      # NOTE install unstable packages by typing: unstable.<packageName>
      git
      micro
      tree
      eza # NOTE ls alternative
      cmatrix
      fastfetch
      disfetch
      btop
      nil # LSP for nix
      wget
      unzip
      neovim
      wl-clipboard
      bc
      nwg-displays # TODO temp, mss configuren zodat het werkt met nix (zie docs https://github.com/nwg-piotr/nwg-displays)
      xwayland-satellite
      wl-clipboard
      nixfmt
    ];
    home.extraOptions.home.packages = with pkgs; [
      # NOTE install unstable packages by typing: unstable.<packageName>
      firefox
      mission-center
      resources # TODO test out this system monito
    ];

    programs.nix-ld.enable = true; # Run unpatched dynamic binaries on NixOS
    home.extraOptions.programs.bash.enable = true; # to let home-manager manage bash config (for custom prompt, aliases, ...)

    # aliases (set for all shell configured with home-manager)
    home.extraOptions.home.shellAliases = {
      # update="dconf dump / | dconf2nix > /etc/nixos/dconf.nix && sudo nixos-rebuild switch";
      cls = "clear";
      ls = "eza -F=auto";
      ll = "eza -algh -F=auto --icons=auto --sort=name --group-directories-first";
      lt = "eza -L2 --tree --icons=auto"; # list folder as tree
      ld = "eza -lhD --icons=auto"; # long list dirs
      ".." = "cd ..";
      "..." = "cd ../..";
      egrep = "egrep --color=auto"; # set color to auto
      mkdir = "mkdir -p"; # make parent directories as needed

      ask = "shell-genie ask";
      arch = "distrobox-enter --root arch";
      hpc = "bash -c 'TERM=xterm-256color ;  ssh vsc47975@login.hpc.ugent.be -i /home/nebilam/.ssh/hpc'"; # NOTE hpc werkt niet met alacritty

      ns = "nix-shell --command fish -p";

      # git aliases
      gst = "git status";
      gl = "git log --graph --all --oneline";
      gln = "git log --oneline origin/HEAD..HEAD"; # log for everything new on this branch compared to main
      gll = "git log -p --ext-diff --graph --all"; # git log long (with external diff tool)
      gd = "git diff";
      gds = "git diff --staged";
      gdo = "git diff --no-ext-diff"; # original git diff (no external diff tool)
    };
  };
}
