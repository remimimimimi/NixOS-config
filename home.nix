{ config, pkgs, emacs-overlay, ... }:
{
  home.packages = [
    pkgs.htop
  ];
  nixpkgs.overlays = [ emacs-overlay.overlay ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
  };
  # Doom emacs config
  xdg.configFile."doom/config.el".source = ''
  '';

  programs.alacritty = {
    enable = true;
    settings = {
      font= {
        normal = {
          family = "Roboto Mono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "Roboto Mono Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "Roboto Mono Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "Roboto Mono Nerd Font Mono";
          style = "Bold Italic";
        };

        size = 11.0;
        offset = {
          x = 1;
          y = 1;
        };
      };

      colors = {
        # Default colors
        primary = {
          background = "0x000000";
          foreground = "0xffffff";
        };
        cursor = {
          text = "0xF81CE5";
          cursor = "0xffffff";
        };

        # Normal colors
        normal = {
          black =   "0x000000";
          red =     "0xfe0100";
          green =   "0x33ff00";
          yellow =  "0xfeff00";
          blue =    "0x0066ff";
          magenta = "0xcc00ff";
          cyan =    "0x00ffff";
          white =   "0xd0d0d0";
        };
        # Bright colors
        bright = {
          black =   "0x808080";
          red =     "0xfe0100";
          green =   "0x33ff00";
          yellow =  "0xfeff00";
          blue =    "0x0066ff";
          magenta = "0xcc00ff";
          cyan =    "0x00ffff";
          white =   "0xFFFFFF";
        };
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };

        blink_interval = 750;
        unfocused_hollow = true;
      };

      shell = {
        program = "zsh";
      };
    };
  };
}
