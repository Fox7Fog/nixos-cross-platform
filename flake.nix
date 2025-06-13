{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Utilities
    flake-utils.url = "github:numtide/flake-utils";

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

  nixConfig = {
    allowUnfree = true;
    builders = "";
    fallback = false;
    substituters = [
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, home-manager, devenv, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // import ./lib { inherit inputs; };
      
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      
      # Generate packages for each system using lib.genAttrs
      forAllSystems = nixpkgs.lib.genAttrs systems;
      
      # Import overlays
      overlays = import ./overlays { inherit inputs; };
      
      # Generate pkgs with overlays for each system (stable)
      pkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlays.unstable overlays.custom ];
      });

      # Generate pkgs with overlays for each system (unstable)
      unstablePkgsFor = forAllSystems (system: import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlays.custom ]; # Potentially different overlays for unstable
      });
      
    in {
      # Custom packages (uncomment and implement ./pkgs when ready)
      
      # Overlays
      overlays = overlays;
      
      # NixOS configurations
      nixosConfigurations = {
        "F7F-NixOS" = lib.mkNixosSystem {
          hostname = "F7F-NixOS";
          system = "x86_64-linux";
          users = [ "fox7fog" ];
          pkgs = pkgsFor."x86_64-linux";
          flakeRoot = self;
        };
        "dell-optiplex" = lib.mkNixosSystem {
          hostname = "dell-optiplex";
          system = "x86_64-linux";
          users = [ "fox7fog" ];
          pkgs = pkgsFor."x86_64-linux";
          flakeRoot = self;
        };
        "thinkpad-x201" = lib.mkNixosSystem {
          hostname = "thinkpad-x201";
          system = "x86_64-linux";
          users = [ "fox7fog" ];
          pkgs = pkgsFor."x86_64-linux";
          flakeRoot = self;
        };
        "hp-microserver" = lib.mkNixosSystem {
          hostname = "hp-microserver";
          system = "x86_64-linux";
          users = [ "fox7fog" ];
          pkgs = pkgsFor."x86_64-linux";
          flakeRoot = self;
        };
      };
      
      
      # Home Manager configurations
      homeConfigurations = {
        "fox7fog@F7F-NixOS" = lib.mkHome {
          username = "fox7fog";
          system = "x86_64-linux";
          pkgs = pkgsFor."x86_64-linux";
          unstable = unstablePkgsFor."x86_64-linux";
          desktop = "hyprland"; # This might need to be conditional or Linux-specific
        };

        "fox7fog@F7F-macOS-arm" = lib.mkHome {
          username = "fox7fog";
          system = "aarch64-darwin";
          pkgs = pkgsFor."aarch64-darwin";
          unstable = unstablePkgsFor."aarch64-darwin";
        };

        "fox7fog@F7F-macOS-intel" = lib.mkHome {
          username = "fox7fog";
          system = "x86_64-darwin";
          pkgs = pkgsFor."x86_64-darwin";
          unstable = unstablePkgsFor."x86_64-darwin";
        };
      };
      
      # Packages (including legacy shell configs)
      packages = forAllSystems (system:
        let
          # Use pkgsFor to ensure consistent pkgs context if needed, though for simple file copying, 
          # nixpkgs.legacyPackages might also work. Using pkgsFor is safer if any tools from your overlays were ever needed.
          pkgs = pkgsFor.${system};
        in
        {
          flakeSnapshot-zshrc = pkgs.runCommandNoCC "flakeSnapshot-zshrc-pkg" { }
            ''
              mkdir -p $out
              cp ${./home/flake_snapshot_shell_configs/zshrc.current} $out/zshrc.current
            '';

          flakeSnapshot-bashrc = pkgs.runCommandNoCC "flakeSnapshot-bashrc-pkg" { }
            ''
              mkdir -p $out
              cp ${./home/flake_snapshot_shell_configs/bashrc.current} $out/bashrc.current
            '';
          
          # You can add other custom packages here if needed in the future
        }
      );
      
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
