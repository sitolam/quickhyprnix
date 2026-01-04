{
  config,
  hostname,
  isInstall,
  isWorkstation,
  inputs,
  outputs,
  lib,
  myLib,
  modulesPath,
  pkgs,
  platform,
  username,
  ...
}:
{
  imports = [
    # inputs.catppuccin.nixosModules.catppuccin
    #inputs.determinate.nixosModules.default
    # inputs.nix-flatpak.nixosModules.nix-flatpak
    # inputs.nix-index-database.nixosModules.nix-index
    # inputs.sops-nix.nixosModules.sops
    (modulesPath + "/installer/scan/not-detected.nix")
    ./${hostname} # NOTE imports the default.nix file in that directory
  ]; # ++ lib.optional isWorkstation ./_mixins/desktop;

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

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.meslo-lg
    ];
  };

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      timeout = 5;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 15;
        # TODO add garbage collector to clean up generations?
        extraEntries = ''
          			menuentry "Reboot" {
          				reboot
          			}
          			menuentry "Poweroff" {
          				halt
          			};
          		'';
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_BE.UTF-8";
    LC_IDENTIFICATION = "nl_BE.UTF-8";
    LC_MEASUREMENT = "nl_BE.UTF-8";
    LC_MONETARY = "nl_BE.UTF-8";
    LC_NAME = "nl_BE.UTF-8";
    LC_NUMERIC = "nl_BE.UTF-8";
    LC_PAPER = "nl_BE.UTF-8";
    LC_TELEPHONE = "nl_BE.UTF-8";
    LC_TIME = "nl_BE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  services.displayManager.gdm.enable = true; # FIXME not working

  services.xserver = {
    xkb = {
      layout = "us";
      variant = "intl";
      # NOTE https://nixos.wiki/wiki/Keyboard_Layout_Customization
    };
  };

  # Configure console keymap
  # console.keyMap = "be-latin1";
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
    # drivers = [ pkgs.hplipWithPlugin ];

  };
  # TODO configure printer
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    initialPassword = "test-vm";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # NOTE see current config at /etc/systemd/logind.conf
  services.logind.settings.Login = {
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
  };

  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;
  # FIXME adds support for wayland with build-vm (still necessary?)
  virtualisation.vmVariant = {
    # Taken from https://github.com/donovanglover/nix-config/commit/0bf134297b3a62da62f9ee16439d6da995d3fbff
    # to enable Hyprland to work on a virtualized GPU.
    virtualisation.qemu.options = [
      "-device virtio-vga-gl"
      "-display sdl,gl=on,show-cursor=off"
      # Wire up pipewire audio
      "-audiodev pipewire,id=audio0"
      "-device intel-hda"
      "-device hda-output,audiodev=audio0"
    ];

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
