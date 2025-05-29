{ config, pkgs, lib, ... }:

{
  imports = [
    ./homebrew.nix
    ./system-preferences.nix
  ];

  # Common Darwin settings
  programs.zsh.enable = true;
  
  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];
}
