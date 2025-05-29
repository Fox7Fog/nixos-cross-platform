{ inputs, outputs, lib }:

{ hostname, system, users, pkgs }:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs outputs; };
  modules = [
    ../systems/nixos/${hostname}
    ../systems/nixos/common
    
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs outputs; };
        users = lib.genAttrs users (user: {
          imports = [ ../home/profiles/${user} ];
        });
      };
    }
  ];
}
