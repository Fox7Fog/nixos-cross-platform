{ config, pkgs, lib, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-size = 2;
      border-radius = 5;
      padding = "5,10";
      layer = "overlay";
      anchor = "top-right";
      background-color = "#1e1e2ecc";
      border-color = "#cba6f7aa";
      text-color = "#cdd6f4";
    };
    
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
