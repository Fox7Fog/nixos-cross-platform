package main

import (
	"fmt"
	"os"
	"os/user"
	"path/filepath"
)

const (
	flakeURLDefault           = "github:yourusername/nixos-cross-platform" // Default, user should update
	localFlakePathRelativeToHome = "nixos-cross-platform"
)

// getFlakeRef determines whether to use a local flake path or a remote URL.
func getFlakeRef() string {
	currentUser, err := user.Current()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error getting current user: %v\n", err)
		return flakeURLDefault // Fallback to default URL
	}
	homeDir := currentUser.HomeDir
	localFlakePath := filepath.Join(homeDir, localFlakePathRelativeToHome)
	flakeNixFile := filepath.Join(localFlakePath, "flake.nix")

	if _, err := os.Stat(localFlakePath); !os.IsNotExist(err) {
		if _, err := os.Stat(flakeNixFile); !os.IsNotExist(err) {
			return localFlakePath
		}
	}
	return flakeURLDefault
}

// generateShellAliases generates the shell aliases and functions as a string.
func generateShellAliases(flakeRef string) string {
	return fmt.Sprintf(`
# =============================================================================
# Dev Shell Aliases - Add these to your ~/.zshrc or ~/.bashrc
# =============================================================================

# Function to enter dev shells from anywhere
dev() {
    local shell_name=\${1:-default}
    local flake_ref="%s"
    
    echo "🚀 Entering \$shell_name development shell..."
    echo "📍 Current directory: \$(pwd)"
    echo "🔧 Using flake: \$flake_ref"
    
    nix develop "\$flake_ref#\$shell_name" --command \$SHELL
}

# Specific shell aliases for convenience
alias dev-rust='dev web-rust'
alias dev-python='dev python'
alias dev-go='dev go'
alias dev-ethereum='dev ethereum'
alias dev-solana='dev solana'
alias dev-default='dev default'

# List available dev shells
dev-list() {
    echo "Available development shells:"
    echo "  • default     - Basic Nix development environment"
    echo "  • web-rust    - Rust web development (trunk, wasm-pack)"
    echo "  • python      - Python development environment"
    echo "  • go          - Go development environment"
    echo "  • ethereum    - Ethereum/Web3 TypeScript development"
    echo "  • solana      - Solana development environment"
    echo ""
    echo "Usage: dev <shell-name>"
    echo "   or: dev-<shell-name>"
}

# Update flake (useful for remote flakes)
dev-update() {
    local flake_ref="%s"
    echo "🔄 Updating flake inputs..."
    nix flake update "\$flake_ref"
}
`, flakeRef, flakeRef)
}

func main() {
	flakeRef := getFlakeRef()

	fmt.Println("Setting up portable dev shell configuration...")
	fmt.Println("")

	fmt.Println(generateShellAliases(flakeRef))

	fmt.Println("")
	fmt.Println(`=============================================================================
INSTALLATION INSTRUCTIONS:
=============================================================================`)
	fmt.Println()
	fmt.Printf("1. Update the FLAKE_URL variable in the Go program (currently: %s) or ensure your local flake exists at ~/%s\n", flakeURLDefault, localFlakePathRelativeToHome)
	fmt.Println("2. Build the Go program: go build -o setup_dev_shells")
	fmt.Println("3. Run the Go program: ./setup_dev_shells")
	fmt.Println("4. Copy the generated aliases from the output to your ~/.zshrc or ~/.bashrc")
	fmt.Println("5. Reload your shell: source ~/.zshrc (or restart terminal)")
	fmt.Println()
	fmt.Println(`USAGE:
• dev web-rust          - Enter Rust web development shell
• dev-python            - Enter Python development shell  
• dev-list              - Show all available shells
• dev-update            - Update flake inputs`)
	fmt.Println()
	fmt.Println("The shells will start in your current directory and won't change your location!")
	fmt.Println(`=============================================================================`)
}
