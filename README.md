# Cross-Platform Nix Configuration

A Nix flake configuration for NixOS and macOS with development environments.

## Quick Start

### NixOS
```bash
sudo nixos-rebuild switch --flake .#F7F
```

### macOS
```bash
darwin-rebuild switch --flake .#MacBook-Intel
home-manager switch --flake .#fox7fog@MacBook-Intel
```

### Development Shells
```bash
# Ethereum development
nix develop .#ethereum

# Solana development  
nix develop .#solana

# Web development with Rust
nix develop .#web-rust
```

## Structure

- `systems/` - System configurations
- `home/` - Home Manager configurations  
- `shells/` - Development environments
- `lib/` - Helper functions
- `overlays/` - Package overlays
- `scripts/` - Management utilities
