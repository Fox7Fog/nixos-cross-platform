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
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    inter
    roboto
  ];
}
