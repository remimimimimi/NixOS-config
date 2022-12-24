{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    guix-overlay.url = "github:foo-dogsquared/nix-overlay-guix";

    mm0.url = "github:digama0/mm0";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils-plus, home-manager, agenix
    , nix-gaming, guix-overlay, mm0 }:
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;

      sharedOverlays = [
        self.overlay
        guix-overlay.overlays.default
        nix-gaming.overlays.default
        (final: prev: { mm0-rs = mm0.packages.${prev.system}.mm0-rs; })
      ];

      # Modules shared between all hosts
      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
        guix-overlay.nixosModules.guix
        # ./modules/sharedConfigurationBetweenHosts.nix
      ];
      # hostDefaults.extraArgs = {
      #
      # };

      hosts.remimimimimi.modules = [ ./hosts/remimimimimi.nix ];

      overlay = import ./overlays;
    };
}
