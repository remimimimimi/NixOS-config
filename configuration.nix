# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, system, inputs, ... }:

let
  pkgs-unstable = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs-on-the-edge = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in {
  imports = [ ./hardware-configuration.nix ./zsh.nix ];

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
      sha256 = "04f58mwvz7pn4z8hxvbxbgzb6cjn360707zd14rvv3zsry58dsgd";
    }))
  ];
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Change kernel version
  boot.kernelPackages = pkgs.linuxPackages_5_4;

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

  # Flatpack setup
  services.flatpak.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Desktop manager
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.extraPackages = haskellPackages: [
    haskellPackages.xmobar
    haskellPackages.xmonad-contrib
  ];
  services.xserver.windowManager.i3.enable = true;
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
  hardware.opengl.driSupport32Bit = true;

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

  fonts = {
      fonts = with pkgs; [
        (nerdfonts.override { fonts = [ "Iosevka" ]; })
        terminus_font
        corefonts
        noto-fonts
      ];
  };

  environment.systemPackages = with pkgs-unstable; [
    wezterm
    arc-icon-theme
    arc-theme
    bat
    bibata-cursors
    binutils
    blender
    clang
    clang-tools
    cmake
    coreutils
    crate2nix
    direnv
    discord
    dmenu
    dunst
    exa
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
    killall
    libpulseaudio
    libreoffice-qt
    libtool
    links2
    mpv
    neofetch
    neovim
    nixfmt
    openssh
    openssl
    papirus-icon-theme
    pass
    qemu
    ranger
    radare2
    ripgrep
    rnix-lsp
    roboto-mono
    rust-analyzer
    rustup
    sccache
    spotify
    ncspot
    starship
    tdesktop
    scc
    tinycc
    unzip
    wget
    wmctrl
    xclip
    xsel
    xmobar
    youtube-dl
    (python3.withPackages (ps:
      with ps; [
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
    tree-sitter
    wineWowPackages.stable
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
  system.stateVersion = "21.11"; # Did you read the comment?
}

