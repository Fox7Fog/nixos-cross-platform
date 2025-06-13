{ pkgs }:

pkgs.mkShell {
  name = "ethereum-dev";
  
  buildInputs = with pkgs; [
    # Node.js and TypeScript
    nodejs
    nodejs.pkgs.npm
    nodejs.pkgs.yarn
    typescript
    
    # Rust tools for Ethereum
    rustc
    cargo
    
    # Python for web3.py
    python3
    python3Packages.web3
    python3Packages.eth-account
    
    # Development utilities
    jq
    curl
    git
  ];
  
  shellHook = ''
    # Set up environment for Ethereum development
    export NIX_SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export SSL_CERT_FILE="$NIX_SSL_CERT_FILE"
    export CARGO_HTTP_CAINFO="$NIX_SSL_CERT_FILE"
    echo "⛓️  Ethereum Development Shell"
    echo "Available tools:"
    echo "  - Node.js $(node --version)"
    echo "  - TypeScript $(tsc --version)"
    echo "  - Truffle $(truffle version | head -1)"
    echo "  - Python $(python --version)"
    echo ""
    echo "Quick start:"
    echo "  truffle init          # Initialize new project"
    echo "  ganache-cli           # Start local blockchain"
    echo "  npm install web3      # Install web3.js"
    
    # Set up environment variables
    export ETH_RPC_URL="http://localhost:8545"
    export CHAIN_ID="1337"
    # Make nxc-dev available in the devShell as a script in PATH
    export PATH="${toString ../scripts}:$PATH"
  '';
}
