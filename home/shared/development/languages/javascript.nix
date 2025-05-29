{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Node.js (stable)
    nodejs
    npm
    yarn
    
    # TypeScript
    typescript
    
    # Tools
    nodePackages.prettier
    nodePackages.eslint
  ];
}
