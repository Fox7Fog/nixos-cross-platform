{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Rust toolchain (stable)
    rustc
    cargo
    rustfmt
    clippy
    
    # Additional tools
    cargo-watch
    cargo-edit
    cargo-audit
  ];
}
