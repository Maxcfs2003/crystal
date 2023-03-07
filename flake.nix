{
  description = "the fuck is this";

  inputs = {
    # Package sources.
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-22.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Channel to follow.
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, home-manager, ... } @inputs:
    let
      inherit (nixpkgs) lib;
      forSystems = lib.genAttrs lib.systems.flakeExposed;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ ];
      };
    in
    {
      # host configurations
      nixosConfigurations = {
        nixl = nixpkgs.lib.nixosSystem
          {
            specialArgs = { inherit inputs; };
            modules = [
              # > Our main nixos configuration file <
              ./hosts/nixl/configuration.nix
            ];
          };
      };
      # user configurations
      homeConfigurations = {
        namish = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs self; };
          modules = [
            ./home
            {
              home.stateVersion = "22.05";
              home.username = "namish";
              home.homeDirectory = "/home/namish";
            }
          ];
        };
      };
      nixl = self.nixosConfigurations.lappy.config.system.build.toplevel;
    };
}
