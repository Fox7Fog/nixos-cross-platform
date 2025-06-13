{ pkgs }:

pkgs.mkShell {
  name = "go-dev";
  
  buildInputs = with pkgs; [
    # Go toolchain
    go
    gopls  # Go language server
    rustc
    cargo
    rustfmt
    clippy
    lld
    
    # Development tools
    golangci-lint
    gotools
    go-tools
    
    # Additional utilities
    air  # Live reload
    
    # Development utilities
    jq
    curl
    git
  ];
  
  shellHook = ''
    # Set up environment for Go development
    export NIX_SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export SSL_CERT_FILE="$NIX_SSL_CERT_FILE"
    export CARGO_HTTP_CAINFO="$NIX_SSL_CERT_FILE"
    
    echo "🐹 Go Development Environment"
    echo "Available tools:"
    echo "  - Go $(go version)"
    echo "  - gopls $(gopls version)"
    echo "  - golangci-lint $(golangci-lint --version)"
    echo ""
    echo "Quick start:"
    echo "  go mod init example.com/myproject  # Initialize module"
    echo "  go run main.go                     # Run application"
    echo "  air                                # Live reload"
    echo "  golangci-lint run                  # Lint code"
    
    # Set up Go environment
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
    # Make nxc-dev available in the devShell
    alias nxc-dev='nix develop ~/nixos-cross-platform'
  '';
}
