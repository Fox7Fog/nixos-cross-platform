{ config, pkgs, lib, ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    
    # Common taps
    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
    ];
    
    # Common brews (prefer BSD/native tools)
    brews = [
      # Only when Nix alternatives don't work well on macOS
    ];
    
    # Common casks
    casks = [
      "font-jetbrains-mono-nerd-font"
    ];
  };
}
