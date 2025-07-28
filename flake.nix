{
  description = "Main flake.nix for rainmaker";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
      };
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.mcp-demo = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.mbrowning = import ./user/home.nix;
            };
          }

          inputs.agenix.nixosModules.default
          {
            environment.systemPackages = [ inputs.agenix.packages.${system}.default ];
          }
        ];
      };
    };
}
