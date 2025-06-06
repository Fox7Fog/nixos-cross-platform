{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Node.js (stable)
    nodejs
    nodejs.pkgs.npm
    yarn
    
    # TypeScript
    typescript
    
    # Tools
    nodePackages.prettier
    nodePackages.eslint
  ];
}
