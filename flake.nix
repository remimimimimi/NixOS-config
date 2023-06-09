{
  description = "My nixos configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils-plus,
    home-manager,
    emacs-overlay,
    alejandra,
  }:
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        (import ./packages)
        emacs-overlay.overlays.emacs
        alejandra.overlay
      ];

      # Modules shared between all hosts
      hostDefaults.modules = [
        home-manager.nixosModules.default
        ./modules
      ];
      hostDefaults.extraArgs = {
        pkgs-unstable = import nixpkgs-unstable {localSystem = "x86_64-linux";};
      };

      hosts.hp.modules = [./hosts/hp];
    };
}
