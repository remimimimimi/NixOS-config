# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <unstable> {
    config = { allowUnfree = true; };
    overlays = [
      (import (builtins.fetchTarball {
        url =
          "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      }))
    ];
  };
in {
  # Allow unfree and unstable packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
    # overlays = [
    #   (self: super: {
    #     discord = super.discord.overrideAttrs (_: {
    #       src = builtins.fetchTarball
    #         "https://dl.discordapp.net/apps/linux/0.0.15/discord-0.0.15.tar.gz";
    #     });
    #   })
    # ];
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./zsh.nix
    ./cachix.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Remimimimi";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Roboto-mono";
    keyMap = "us";
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "us";
    autoRepeatDelay = 210;
    autoRepeatInterval = 40;

    desktopManager.plasma5.enable = true;
    windowManager.bspwm = {
      enable = true;
      configFile = "/home/remimimimi/.config/bspwm/bspwmrc";
      sxhkd.configFile = "/home/remimimimi/.config/sxhkd/sxhkdrc";
    };
  };

  # Desktop manager

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.enableAllFirmware = true;

  # Setup docker
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.remimimimi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    home = "/home/remimimimi";
    description = "remimimimi";
    shell = pkgs.zsh;
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "RobotoMono" ]; })
    font-awesome
    noto-fonts-emoji
    carlito
    dejavu_fonts
    ipafont
    kochi-substitute
    source-code-pro
    ttf_bitstream_vera
  ];

  environment.systemPackages = with unstable; [
    arc-icon-theme
    arc-theme
    bat
    bibata-cursors
    binutils
    cdrkit
    clang
    clang-tools
    cmake
    coreutils
    crate2nix
    deno
    direnv
    discord
    dmenu
    dunst
    element-desktop
    exa
    fd
    feh
    firefox
    flameshot
    gcc
    git
    gitAndTools.delta
    gitAndTools.gh
    gnumake
    just
    kakoune
    killall
    libpulseaudio
    libreoffice-qt
    libtool
    links2
    mpv
    neofetch
    nixfmt
    openssh
    openssl
    papirus-icon-theme
    pass
    qemu
    qutebrowser
    ranger
    ripgrep
    rnix-lsp
    roboto-mono
    rust-analyzer
    rustup
    sccache
    spotify
    starship
    tdesktop
    tokei
    unzip
    wget
    xclip
    xsel
    youtube-dl
    (unstable.python3.withPackages
      (ps: with ps; [ pytest nose black pyflakes isort cython jedi ]))
    python-language-server
    unstable.nodePackages.pyright
    unstable.poetry
    unstable.pipenv
    unstable.radare2
    polybarFull
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.emacs.enable = true;
  services.emacs.package = with unstable;
    ((emacsPackagesNgGen emacsGcc).emacsWithPackages (epkgs: [ epkgs.vterm ]));

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
