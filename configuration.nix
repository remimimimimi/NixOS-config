# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let unstable = import <nixos-unstable> { allowUnfree = true; };
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
  ];

  nixpkgs.overlays = [ (import ./nix-nerd-fonts-overlay/default.nix) ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ScarletDevilMansion"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "FiraCode Nerd Font";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs; [ nerd-fonts.firacode ];

  services.picom = {
    fade = true;
    fadeSteps = [ "0.15" "0.15" ];
    backend = "glx";
    # shadow = true;
    # shadowOffsets = [ (-10) (-10) ];
    # shadowOpacity = "0.22";
    # activeOpacity = "1.00";
    # inactiveOpacity = "0.92";
    settings = {
      blur-background = true;
      blur-background-frame = true;
      blur-background-fixed = true;

      blur-kern = "3x3box";
      blur-method = "dual_kawase";
      blur-strength = 5;
      blur-background-exclude = [ "class_g = 'slop'" ];
    };
  };

  environment.systemPackages = with pkgs; [
    alacritty
    arc-icon-theme
    arc-theme
    binutils
    carnix
    clang
    cmake
    coreutils
    discord
    dunst
    ((emacsPackagesNgGen emacs).emacsWithPackages
    emojione
      (epkgs: [ epkgs.emacs-libvterm ]))
    fd
    feh
    firefox-devedition-bin
    fish
    flameshot
    font-awesome
    gcc
    git
    gnumake
    kakoune
    killall
    libpulseaudio
    libtool
    links2
    links2
    neofetch
    nixfmt
    openssh
    openssl
    papirus-icon-theme
    picom
    ranger
    ripgrep
    rustup
    sccache
    starship
    tdesktop
    #unstable.emacs
    unstable.rust-analyzer
    unzip
    wget
    xclip
  ];

  environment.shellAliases = {
    nix-env = "NIXPKGS_ALLOW_UNFREE=1 nix-env";
    nsh = "nix-shell";
    nen = "nix-env";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.autorun = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # window manager
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.xserver.windowManager.i3.extraPackages = with pkgs; [
    dmenu
    i3status
    i3lock
  ];

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.remi = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
    home = "/home/remi";
    description = "Remilia Scarlet";
    shell = pkgs.fish;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

