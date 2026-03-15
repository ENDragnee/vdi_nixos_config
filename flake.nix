{
  description = "VDI Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    ...
  } @ inputs: {
    nixosConfigurations.vdi = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};

      modules = [
        ./configuration.nix

        impermanence.nixosModules.impermanence

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.sharedModules = [
            {home.stateVersion = "25.05";}
          ];

          home-manager.users.vdi = {
            imports = [
              ./home.nix
              impermanence.nixosModules.home-manager.impermanence
            ];
          };
        }
      ];
    };
  };
}
