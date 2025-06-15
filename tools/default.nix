{ pkgs }:

{
  # Go program for system updates (replaces system-update script)
  system-updater = pkgs.buildGoModule {
    pname = "system-updater";
    version = "0.1.0"; # You can update this version as needed
    src = ./system_updater_go;
    vendorHash = ""; # Nix will prompt for the correct hash on first build
    # Module path from its go.mod: github.com/fox7fog/nixos-cross-platform/system_updater
    # The resulting executable will be named 'system-updater'
  };
  
  # Go program for managing development shells (replaces dev-env script)
  dev-shell-manager = pkgs.buildGoModule {
    pname = "dev-shell-manager";
    version = "0.1.0"; # You can update this version as needed
    src = ./dev_shell_manager_go;
    vendorHash = ""; # Nix will prompt for the correct hash on first build
    # Module path from its go.mod: github.com/fox7fog/nixos-cross-platform/dev_shell_manager
    # The resulting executable will be named 'dev-shell-manager'
  };

  # Script to generate dev shell aliases (Go version)
  setup-dev-shells = pkgs.buildGoModule {
    pname = "setup-dev-shells";
    version = "0.1.0"; # You can update this version as needed
    src = ./setup_dev_shells_go;
    vendorHash = ""; # Nix will prompt for the correct hash on first build if needed
    # The module path is github.com/fox7fog/nixos-cross-platform/setup_dev_shells
    # The resulting executable will be named 'setup_dev_shells'
  };

  # Go program to install dev shell functions into user's shell config
  dev-env-installer = pkgs.buildGoModule {
    pname = "dev-env-installer";
    version = "0.1.0"; # You can update this version as needed
    src = ./dev-env-installer-go; # Relative to this default.nix file
    vendorHash = ""; # Nix will prompt for the correct hash on first build
    # Module path from its go.mod: github.com/fox7fog/nixos-cross-platform/dev-env-installer-go
    # The resulting executable will be named 'dev-env-installer'
  };

  # Go program to run 'nix develop ~/nixos-cross-platform ...args'
  flake-runner = pkgs.buildGoModule {
    pname = "flake-runner";
    version = "0.1.0"; # You can update this version as needed
    src = ./flake_runner_go; # Relative to this default.nix file
    vendorHash = null; # No dependencies for this module
    # Module path from its go.mod: github.com/fox7fog/nixos-cross-platform/flake_runner
    # The resulting executable will be named 'flake-runner'
  };
}
