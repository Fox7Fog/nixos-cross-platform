{
  description = "Cross-Platform Nix Configuration (NixOS + macOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Development environments
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, devenv, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // import ./lib { inherit inputs outputs; };
      
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      
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
      packages = forAllSystems (system: import ./pkgs { pkgs = pkgsFor.${system}; });
      
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
      
      # Darwin configurations
      darwinConfigurations = {
        MacBook-Intel = lib.mkDarwinSystem {
          hostname = "MacBook-Intel";
          system = "x86_64-darwin";
          users = [ "fox7fog" ];
          pkgs = pkgsFor."x86_64-darwin";
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
        "fox7fog@MacBook-Intel" = lib.mkHome {
          username = "fox7fog";
          system = "x86_64-darwin";
          pkgs = pkgsFor."x86_64-darwin";
          desktop = "darwin";
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
