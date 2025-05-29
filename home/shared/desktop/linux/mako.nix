{ config, pkgs, lib, ... }:

{
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    borderSize = 2;
    borderRadius = 5;
    padding = "5,10";
    layer = "overlay";
    anchor = "top-right";
    backgroundColor = "#1e1e2ecc";
    borderColor = "#cba6f7aa";
    textColor = "#cdd6f4";
    
    extraConfig = ''
      [urgency=high]
      border-color=#f38ba8
      default-timeout=0
      
      [app-name=volume]
      border-color=#89b4fa
      default-timeout=2000
      
      [app-name=brightness]
      border-color=#f9e2af
      default-timeout=2000
    '';
  };
}
