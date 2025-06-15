{ pkgs }:

pkgs.mkShell {
  name = "web-rust-dev";
  
  buildInputs = with pkgs; [
    # Rust toolchain
    rustc
    cargo
    rustfmt
    clippy
    
    # Web development tools
    trunk  # WASM web application bundler
    wasm-pack
    lld
    
    # Additional Rust tools
    cargo-watch
    cargo-edit
    cargo-generate
    
    # Node.js for frontend tooling
    nodejs
    nodejs.pkgs.npm
    
    # Development utilities
    jq
    curl
    git
  ];
  
  shellHook = ''
    echo "🦀 Web Development with Rust"
    echo "Available tools:"
    echo "  - Rust $(rustc --version)"
    echo "  - Trunk $(trunk --version)"
    echo "  - wasm-pack $(wasm-pack --version)"
    echo "  - Node.js $(node --version)"
    echo ""
    echo "Quick start:"
    echo "  cargo generate --git https://github.com/rustwasm/wasm-pack-template  # WASM library"
    echo "  trunk init                    # Initialize Trunk project"
    echo "  trunk serve                   # Start development server"
    echo "  wasm-pack build              # Build WASM package"
    
    # Add wasm32 target
    rustup target add wasm32-unknown-unknown
    
    # Set up environment
    export NIX_SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export SSL_CERT_FILE="$NIX_SSL_CERT_FILE"
    export CARGO_HTTP_CAINFO="$NIX_SSL_CERT_FILE"
    export RUST_LOG="debug"

    # Make nxc-dev available in the devShell as a script in PATH
    export PATH="${toString ../scripts}:$PATH"
  '';
}
