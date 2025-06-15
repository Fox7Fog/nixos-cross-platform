package main

import (
	"fmt"
	"os"
	"os/exec"
	"runtime"
)

// runCommand executes a command and prints its output/error streams.
// It also prints a message before executing the command.
func runCommand(message string, commandName string, args ...string) error {
	fmt.Println(message)
	cmd := exec.Command(commandName, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin // For commands that might require input (like sudo password)

	err := cmd.Run()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error executing %s %v: %v\n", commandName, args, err)
	}
	return err
}

func main() {
	fmt.Println("🔄 Updating system...")

	var err error

	switch runtime.GOOS {
	case "darwin":
		fmt.Println("📱 Updating macOS system...")
		err = runCommand("Running darwin-rebuild switch...", "darwin-rebuild", "switch", "--flake", ".")
		if err != nil {
			fmt.Println("✅ darwin-rebuild completed (possibly with errors).") // Still try home-manager
		} else {
			fmt.Println("✅ darwin-rebuild switch completed successfully.")
		}

		errHM := runCommand("Running home-manager switch...", "home-manager", "switch", "--flake", ".")
		if errHM != nil {
			fmt.Println("✅ home-manager switch completed (possibly with errors).")
		} else {
			fmt.Println("✅ home-manager switch completed successfully.")
		}
		// Overall success depends on both, but we report individually.
		if err != nil || errHM != nil {
		    fmt.Println("⚠️ Some update commands encountered errors.")
		} else {
		    fmt.Println("✅ macOS system update process complete!")
		}

	case "linux":
		fmt.Println("🐧 Updating NixOS system...")
		// Note: sudo might prompt for a password. Stdin is connected.
		err = runCommand("Running sudo nixos-rebuild switch...", "sudo", "nixos-rebuild", "switch", "--flake", ".")
		if err != nil {
			fmt.Println("⚠️ NixOS system update encountered errors.")
		} else {
			fmt.Println("✅ NixOS system update complete!")
		}

	default:
		fmt.Fprintf(os.Stderr, "Unsupported operating system: %s\n", runtime.GOOS)
		os.Exit(1)
	}

	if err != nil {
	    // Exit with 1 if any of the primary commands failed, allowing scripts to check status.
	    // For macOS, we consider it an overall failure if either darwin-rebuild or home-manager fails significantly.
	    // The individual error messages would have already been printed.
		os.Exit(1)
	}
}
