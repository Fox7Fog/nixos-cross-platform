package main

import (
	"fmt"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"
	"strings"
)

func main() {
	currentUser, err := user.Current()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error getting current user: %v\n", err)
		os.Exit(1)
	}
	homeDir := currentUser.HomeDir
	flakePath := filepath.Join(homeDir, "nixos-cross-platform")

	// The first argument to os.Args is the program name, so skip it.
	args := os.Args[1:]

	// Construct the command for nix develop
	cmdArgs := []string{"develop", flakePath}
	cmdArgs = append(cmdArgs, args...)

	fmt.Printf("Executing: nix %s\n", strings.Join(cmdArgs, " "))

	cmd := exec.Command("nix", cmdArgs...)

	// Set the command's Stdin, Stdout, and Stderr to the current process's
	// to allow for interactive use and to see output/errors.
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		// The error from cmd.Run() will often be an *exec.ExitError,
		// which includes the exit code. Nix commands often use non-zero
		// exit codes for various reasons, not just fatal errors.
		// So, we just print the error and exit with the same code if possible.
		if exitError, ok := err.(*exec.ExitError); ok {
			os.Exit(exitError.ExitCode())
		} else {
			fmt.Fprintf(os.Stderr, "Error executing command: %v\n", err)
			os.Exit(1)
		}
	}
}
