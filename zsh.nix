{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      customPkgs = [ pkgs.nix-zsh-completions ];
    };

    syntaxHighlighting = {
      enable = true;
    };

    enableCompletion = true;

    autosuggestions = {
      enable = true;
    };

    shellAliases = {
      weather = "curl wttr.in";
      j = "just";

      e = "kak";
      tsm = "transmission-remote";
      py = "python3";
      python = "python3";
      sr = "sr -browser=qutebrowser";
      srg = "sr -browser=qutebrowser google ";
      cat = "bat --paging=never";
      tt = "taskwarrior-tui";

      ls = "exa";
      ll = "exa -l";
      la = "exa -la";

      # Rust aliases
      stable = "rustup default stable";
      nightly = "rustup default nightly";
      cr = "cargo run";
      crr = "cargo run --release";
      cb = "cargo build";
      cbr = "cargo build --release";
      ct = "cargo test";
      cch = "cargo check";
      ccl = "cargo clean";
      cx = "cargo xtask";

      # Zig aliases
      zr = "zig run";
      zbr = "zig build run";
      zb = "zig build";

      # git alias
      s = "git status";
      a = "git add";
      c = "git commit";
      cpo = "git commit && git push origin";
      cpom = "git commit && git push origin master";
      p = "git push origin";
      d = "git diff";

      # pulse audio
      hearvoice = "pactl load-module module-loopback adjust_time=0 latency_msec=1 >> /dev/null";
      unhearvoice = "pactl unload-module module-loopback";

      # Nix
      nsh = "nix-shell --command zsh";
      nia = "nix-env -iA";
      nors = "sudo nixos-rebuild switch";
      nd = "nix develop";
    };

    promptInit = ''
      eval "$(starship init zsh)"
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

      export EDITOR="emacs -nw"
      export PAGER="bat"
      export MANPAGER="bat"
      export RUSTC_WRAPPER="sccache"
      # export GTK_THEME="Arc:dark"
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.emacs.d/bin:$PATH"
    '';
  };
}
