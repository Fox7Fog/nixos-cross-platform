{ inputs, lib, config, pkgs, desktop ? null, ... }:

{
  home = {
    username = "fox7fog";
    stateVersion = "25.05";
    # Set homeDirectory based on the OS, ensuring it's defined early.
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/fox7fog"
                    else if pkgs.stdenv.isLinux then "/home/fox7fog"
                    else throw "Unsupported OS for home.homeDirectory definition";
  };

  imports = [
    ../../shared
  ];

  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  # Direnv configuration to ensure .envrc files are used
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Enables 'use flake' and other Nix-specific direnv functions
  };

  # Neovim Configuration is now handled in home/shared/editors/neovim/default.nix
}
