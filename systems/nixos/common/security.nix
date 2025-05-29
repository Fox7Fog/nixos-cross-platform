{ config, pkgs, lib, ... }:

{
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
  
  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };
}
