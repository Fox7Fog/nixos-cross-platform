{ inputs, lib }:

{ hostname, system, users, pkgs, extraModules ? [], flakeRoot }: 

inputs.nixpkgs.lib.nixosSystem {
  inherit pkgs;
  inherit system;
  specialArgs = { inherit inputs; };
  modules = (map (m: "${flakeRoot}/${m}") extraModules) ++ [ # Prepend flakeRoot to extraModules
    ../systems/nixos/${hostname}
    ../systems/nixos/common
    
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };

        users = lib.genAttrs users (user: {
          imports = [ ../home/profiles/${user} ];
        });
      };
    }
  ];
}
