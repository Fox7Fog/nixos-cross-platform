{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Python (stable)
    python3
    python3Packages.pip
    python3Packages.virtualenv
    
    # Development tools
    python3Packages.black
    python3Packages.flake8
    python3Packages.mypy
  ];
}
