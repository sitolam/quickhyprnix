{
  description = "Nebilam's NixOS config with flakes";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # stylix.url = "github:danth/stylix";

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";

    # niri plugins
    niri-tweaks = {
      url = "github:heyoeyo/niri_tweaks";
      flake = false; # important
    };
    nsticky.url = "github:lonerOrz/nsticky";

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia-plugins = {
      url = "github:noctalia-dev/noctalia-plugins";
      flake = false;
    };

    # Custom dotfiles for illogical impulse
    dotfiles = {
      url = "git+https://github.com/sitolam/dots-hyprland?submodules=1";
      flake = false;
    };

    illogical-flake = {
      url = "github:soymou/illogical-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dotfiles.follows = "dotfiles"; # Override to use your dotfiles
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      # inherit (self) outputs;
      # stateVersion = "23.05"; # FIXME not necessary because never changes (can be hardcoded)
      myLib = import ./lib {
        inherit (self) outputs;
        inherit (nixpkgs) lib;
        # inherit pkgs;
        inherit inputs;
        inherit (inputs) home-manager;
        # inherit stateVersion;
      };
    in

    {
      nixosConfigurations = {
        gamingpc = myLib.custom.mkHost {
          hostname = "gamingpc";
          username = "otis";
          desktop = "nirri";
        };
        xps15 = myLib.custom.mkHost {
          hostname = "xps15";
          username = "otis";
          desktop = "nirri";
        };
        usb = myLib.custom.mkHost {
          hostname = "usb";
          username = "otis";
          desktop = "nirri";
        };
      };
      overlays = import ./overlays { inherit inputs; };
    };
}
