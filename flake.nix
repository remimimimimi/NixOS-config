{
  description = "Flake-driven nixos config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/master";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Extra
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };
  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      userName = "remimimimi";
      system = "x86_64-linux";
    in {
      nixosConfigurations.${userName} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
		  ./configuration.nix 
		  home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userName} = import ./home.nix {
              inherit inputs system;
              pkgs = import nixpkgs { inherit system; };
            };
          }
		];
        specialArgs = { inherit system inputs; };
      };
    };
}
