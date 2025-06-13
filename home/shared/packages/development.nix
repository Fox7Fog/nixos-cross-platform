{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Version control
    git
    gh
    
    # Build tools
    gnumake
    cmake
    
    # Language servers
    nil  # Nix LSP
    rust-analyzer
    nodePackages.typescript-language-server
    python3Packages.python-lsp-server
    
    # Debugging
    gdb
    lldb

    # Languages
    php

  ];
}
