{ pkgs }:

{
  # System management scripts
  system-update = pkgs.writeShellScriptBin "system-update" ''
    #!/usr/bin/env bash
    set -euo pipefail
    
    echo "🔄 Updating system..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "📱 Updating macOS system..."
      darwin-rebuild switch --flake .
      home-manager switch --flake .
    else
      echo "🐧 Updating NixOS system..."
      sudo nixos-rebuild switch --flake .
    fi
    
    echo "✅ System update complete!"
  '';
  
  # Development environment manager
  dev-env = pkgs.writeShellScriptBin "dev-env" ''
    #!/usr/bin/env bash
    set -euo pipefail
    
    case "''${1:-}" in
      eth|ethereum)
        echo "🚀 Starting Ethereum development environment..."
        nix develop .#ethereum
        ;;
      sol|solana)
        echo "⚡ Starting Solana development environment..."
        nix develop .#solana
        ;;
      rust|web-rust)
        echo "🦀 Starting Web Rust development environment..."
        nix develop .#web-rust
        ;;
      py|python)
        echo "🐍 Starting Python development environment..."
        nix develop .#python
        ;;
      go)
        echo "🐹 Starting Go development environment..."
        nix develop .#go
        ;;
      *)
        echo "Available development environments:"
        echo "  eth, ethereum    - Ethereum/Web3 TypeScript development"
        echo "  sol, solana      - Solana Rust development"
        echo "  rust, web-rust   - Web development with Rust"
        echo "  py, python       - Python development"
        echo "  go               - Go development"
        echo ""
        echo "Usage: dev-env <environment>"
        ;;
    esac
  '';
}
