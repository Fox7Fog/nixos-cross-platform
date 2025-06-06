{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    

    # Development environments
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, devenv, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // import ./lib { inherit inputs; };
      
      systems = [ "x86_64-linux" ];
      
      # Generate packages for each system
      forAllSystems = nixpkgs.lib.genAttrs systems;
      
      # Import overlays
      overlays = import ./overlays { inherit inputs; };
      
      # Generate pkgs with overlays for each system
      pkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlays.unstable overlays.custom ];
      });
      
    in {
      # Custom packages
      # packages = forAllSystems (system: import ./pkgs { pkgs = pkgsFor.${system}; });  # commented out, pkgs directory does not exist
      
      # Overlays
      overlays = overlays;
      
      # NixOS configurations
      nixosConfigurations = {
        F7F = lib.mkNixosSystem {
          hostname = "F7F";
          system = "x86_64-linux";
          users = [ "fox7fog" ];
          pkgs = pkgsFor."x86_64-linux";
        };
      };
      
      
      # Home Manager configurations
      homeConfigurations = {
        "fox7fog@F7F" = lib.mkHome {
          username = "fox7fog";
          system = "x86_64-linux";
          pkgs = pkgsFor."x86_64-linux";
          desktop = "hyprland";
        };
      };
      
      # Development shells
      devShells = forAllSystems (system: {
        default = pkgsFor.${system}.mkShell {
          packages = with pkgsFor.${system}; [ nixd nil ];
        };
        
        # Web3 Ethereum TypeScript development
        ethereum = import ./shells/ethereum.nix { pkgs = pkgsFor.${system}; };
        
        # Solana Rust development
        solana = import ./shells/solana.nix { pkgs = pkgsFor.${system}; };
        
        # Web development with Rust
        web-rust = import ./shells/web-rust.nix { pkgs = pkgsFor.${system}; };
        
        # Python development
        python = import ./shells/python.nix { pkgs = pkgsFor.${system}; };
        
        # Go development
        go = import ./shells/go.nix { pkgs = pkgsFor.${system}; };
      });
      
      # Templates
      templates = import ./templates;
    };
}
