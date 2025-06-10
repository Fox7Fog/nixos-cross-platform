{
  config,
  pkgs,
  lib,
  unstable, # Passed from mkHome if needed
  inputs,   # Passed from specialArgs in mkHome
  ... 
}:

{
  imports = [
    # Example: import shared configurations if applicable
    # ../../shared/git.nix # If you have a shared git config
    ../../shared/ssh.nix # If you want the same SSH agent setup as Linux
  ];

  # macOS-specific packages (initially empty, as per your current-macos-home-manager-flake/home.nix)
  home.packages = with pkgs; [
    # Add macOS specific packages here, e.g.:
    # mactex
    # skhd
    # yabai
    llvm
  ];

  # macOS-specific settings
  # Example: programs.iterm2.enable = true;

  # Ensure state version is set, can also be in common default.nix
  home.stateVersion = "25.05"; # Or your desired state version

  # Enable Zsh management by Home Manager
  programs.zsh.enable = true;

  # programs.home-manager.enable is already true in common default.nix
}
