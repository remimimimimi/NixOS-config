{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [direnv starship];
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      customPkgs = [pkgs.nix-zsh-completions];
    };

    syntaxHighlighting.enable = true;

    enableCompletion = true;

    autosuggestions.enable = true;

    shellAliases = {
      weather = "curl wttr.in";

      py = "python3";
      python = "python3";

      # pulse audio
      hearvoice = "pactl load-module module-loopback adjust_time=0 latency_msec=1 >> /dev/null";
      unhearvoice = "pactl unload-module module-loopback";

      nors = "sudo nixos-rebuild switch --flake /home/remi/Projects/Mine/NixOS-config#remimimimimi"; # TODO
    };

    promptInit = ''
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
    '';

    shellInit = ''
      ex()
      {
          if [ -f $1 ]; then
              case $1 in
                  *.tar.bz2) tar xjf $1 ;;
                  *.tar.gz) tar xzf $1 ;;
                  *.bz2) bunzip2 $1 ;;
                  *.rar) unrar x $1 ;;
                  *.gz) gunzip $1 ;;
                  *.tar) tar xf $1 ;;
                  *.tbz2) tar xjf $1 ;;
                  *.tgz) tar xzf $1 ;;
                  *.zip) unzip $1 ;;
                  *.Z)  uncompress $1 ;;
                  *.7Z) 7z x $1 ;;
                  *.deb) ar x $1 ;;
                  *.tar.xz) tar xf $1 ;;
                  *) echo "'$1' cannot be extracted vai ex()" ;;
               esac
           else
               echo "'$1' is not a valid file"
           fi
      }
      # TODO: Move to environment.variables
      export EDITOR="emacsclient"
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
