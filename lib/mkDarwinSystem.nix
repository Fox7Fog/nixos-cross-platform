{ inputs, outputs, lib }:

{ hostname, system, users, pkgs }:

inputs.nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = { inherit inputs outputs; };
  modules = [
    ../systems/darwin/${hostname}
    ../systems/darwin/common
    
    inputs.home-manager.darwinModules.home-manager
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
