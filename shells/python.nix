{ pkgs }:

pkgs.mkShell {
  name = "python-dev";
  
  buildInputs = with pkgs; [
    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.poetry
    
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
  '';
}
