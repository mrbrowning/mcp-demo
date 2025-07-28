{
  description = "Main flake.nix for rainmaker";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/32a4e87942101f1c9f9865e04dc3ddb175f5f32e";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
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
        ];
      };
    };
}
