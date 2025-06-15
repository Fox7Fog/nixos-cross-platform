{ pkgs }:

pkgs.mkShell {
  name = "solana-dev";
  
  buildInputs = with pkgs; [
    # Rust toolchain
    rustc
    cargo
    rustfmt
    clippy
    lld
    
    # Solana CLI tools
    solana-cli
    
    # Additional Rust tools
    cargo-watch
    cargo-edit
    
    # Node.js for client development
    nodejs
    nodejs.pkgs.npm
    
    # Development utilities
    jq
    curl
    git
  ];
  
  shellHook = ''
    echo "⚡ Solana Development Environment"
    echo "Available tools:"
    echo "  - Rust $(rustc --version)"
    echo "  - Solana CLI $(solana --version)"
    echo "  - Cargo $(cargo --version)"
    echo "  - Node.js $(node --version)"
    echo ""
    echo "Quick start:"
    echo "  solana-keygen new           # Generate new keypair"
    echo "  solana config set --url devnet  # Set to devnet"
    echo "  cargo init --name my-program     # Initialize Rust program"
    echo "  anchor init my-project           # Initialize Anchor project"
    
    # Set up Solana environment
    export NIX_SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export SSL_CERT_FILE="$NIX_SSL_CERT_FILE"
    export CARGO_HTTP_CAINFO="$NIX_SSL_CERT_FILE"
    export SOLANA_CLUSTER="devnet"
    export RUST_LOG="solana_runtime::system_instruction_processor=trace,solana_runtime::message_processor=debug,solana_bpf_loader=debug,solana_rbpf=debug"
    # Make nxc-dev available in the devShell as a script in PATH
    export PATH="${toString ../scripts}:$PATH"
  '';
}
