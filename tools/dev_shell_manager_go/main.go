package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func printUsage() {
	fmt.Println("Available development environments:")
	fmt.Println("  eth, ethereum    - Ethereum/Web3 TypeScript development")
	fmt.Println("  sol, solana      - Solana Rust development")
	fmt.Println("  rust, web-rust   - Web development with Rust")
	fmt.Println("  py, python       - Python development")
	fmt.Println("  go               - Go development")
	fmt.Println("  (default)        - Basic Nix development environment (if no arg or 'default' is given)")
	fmt.Println("")
	fmt.Println("Usage: dev-shell-manager <environment>")
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("🚀 Entering default Nix development shell...")
		executeNixDevelop("default")
		return
	}

	shellArg := strings.ToLower(os.Args[1])
	var shellName string

	switch shellArg {
	case "eth", "ethereum":
		shellName = "ethereum"
		fmt.Println("🚀 Starting Ethereum development environment...")
	case "sol", "solana":
		shellName = "solana"
		fmt.Println("⚡ Starting Solana development environment...")
	case "rust", "web-rust":
		shellName = "web-rust"
		fmt.Println("🦀 Starting Web Rust development environment...")
	case "py", "python":
		shellName = "python"
		fmt.Println("🐍 Starting Python development environment...")
	case "go":
		shellName = "go"
		fmt.Println("🐹 Starting Go development environment...")
	case "default":
		shellName = "default"
		fmt.Println("🚀 Entering default Nix development shell...")
	default:
		fmt.Printf("Error: Unknown development environment '%s'\n\n", shellArg)
		printUsage()
		os.Exit(1)
	}

	executeNixDevelop(shellName)
}

func executeNixDevelop(shellName string) {
	flakeArg := fmt.Sprintf(".#%s", shellName)
	cmd := exec.Command("nix", "develop", flakeArg)

	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		if exitError, ok := err.(*exec.ExitError); ok {
			os.Exit(exitError.ExitCode())
		} else {
			fmt.Fprintf(os.Stderr, "Error executing command: %v\n", err)
			os.Exit(1)
		}
	}
}
