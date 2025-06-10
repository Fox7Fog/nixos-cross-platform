{ config, pkgs, lib, ... }:

{
  imports = [
    ./users.nix
    ./security.nix
    ./networking.nix
  ];

  # Common system settings
  console.keyMap = "us";
  
  # Fonts
  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
    inter
    roboto
  ];
}
