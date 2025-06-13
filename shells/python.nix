{ pkgs }:

pkgs.mkShell {
  name = "python-dev";
  
  buildInputs = with pkgs; [
    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    poetry
    python3Packages.poetry-core
    
    # Development tools
    python3Packages.black
    python3Packages.flake8
    python3Packages.mypy
    python3Packages.pytest
    python3Packages.ipython
    python3Packages.jupyter
    
    # Common libraries
    python3Packages.requests
    python3Packages.numpy
    python3Packages.pandas
    python3Packages.matplotlib
    
    # Development utilities
    jq
    curl
    git
  ];
  
  shellHook = ''
    # Set up environment for Python development
    export NIX_SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export SSL_CERT_FILE="$NIX_SSL_CERT_FILE"
    export CARGO_HTTP_CAINFO="$NIX_SSL_CERT_FILE"
    echo "🐍 Python Development Environment"
    echo "Available tools:"
    echo "  - Python $(python --version)"
    echo "  - Poetry $(poetry --version)"
    echo "  - Black $(black --version)"
    echo "  - Jupyter $(jupyter --version)"
    echo ""
    echo "Quick start:"
    echo "  poetry init                   # Initialize new project"
    echo "  python -m venv venv          # Create virtual environment"
    echo "  source venv/bin/activate     # Activate virtual environment"
    echo "  jupyter notebook             # Start Jupyter"
    
    # Set up Python environment
    export PYTHONPATH="$PWD:$PYTHONPATH"
    # Make nxc-dev available in the devShell
    alias nxc-dev='nix develop ~/nixos-cross-platform'
  '';
}
