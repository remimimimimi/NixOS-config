# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, system, inputs, ... }:

let
  pkgs-unstable = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in {
  imports = [ ./hardware-configuration.nix ./cachix.nix ./zsh.nix ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "0kwkilg33rl3pfqnl2g6bsam03f8byf06a3y86hk1fsblk48d4d4";
    }))
  ];
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sdm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

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
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Desktop manager
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.xserver.windowManager.i3.extraPackages = with pkgs; [
    dmenu
    i3status-rust
    i3lock
  ];

  # Configure keyboard settings in X11
  services.xserver.layout = "us";
  services.xserver.autoRepeatDelay = 210;
  services.xserver.autoRepeatInterval = 40;
  services.xserver.xkbOptions = "ctrl:swapcaps";

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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

  environment.systemPackages = with pkgs-unstable; [
    alacritty
    arc-icon-theme
    arc-theme
    bat
    bibata-cursors
    binutils
    cached-nix-shell
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
    fd
    feh
    firefox-devedition-bin
    flameshot
    gcc
    git
    gitAndTools.delta
    gitAndTools.gh
    gnumake
    home-manager
    just
    kakoune
    killall
    libpulseaudio
    libreoffice-qt
    libtool
    links2
    lua5_3
    mpv
    neofetch
    neovim
    nixfmt
    openssh
    openssl
    papirus-icon-theme
    pass
    qemu
    qutebrowser
    ranger
    radare2
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
    tinycc
    unzip
    wget
    wget
    wmctrl
    xclip
    xsel
    youtube-dl
    (python3.withPackages (ps:
      with ps; [
        python-language-server
        pytest
        nose
        black
        pyflakes
        isort
        cython
      ]))
    python-language-server
    (vscode-with-extensions.override {
      vscodeExtensions =
        (with vscode-extensions; [ ms-vsliveshare ms-vscode-remote ]);
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Emacs as daemon
  services.emacs.enable = true;
  services.emacs.package =
    (pkgs.emacsPackagesGen pkgs.emacsPgtkGcc).emacsWithPackages
    (epkgs: [ epkgs.vterm ]);
  #services.emacs.package = ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]));

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

