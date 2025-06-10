{
  inputs, lib, flakeRoot ? null }: # flakeRoot is passed from flake.nix but not strictly needed here yet

{ username, system, pkgs, unstable ? null, desktop ? null }:

let
  cleanInputs = builtins.removeAttrs inputs [ "self" ];

  # Determine the OS-specific profile file name
  osProfileName = if pkgs.stdenv.isLinux then "linux.nix"
                  else if pkgs.stdenv.isDarwin then "darwin.nix"
                  else null;

  # Base profile path
  userProfilePath = ../home/profiles/${username};

  # List of modules to import
  profileModules = [
    # Common profile (e.g., home/profiles/fox7fog/default.nix)
    userProfilePath
  ] ++ lib.optional (osProfileName != null && builtins.pathExists (userProfilePath + "/" + osProfileName)) (
    # OS-specific profile (e.g., home/profiles/fox7fog/linux.nix or darwin.nix)
    userProfilePath + "/" + osProfileName
  );

in inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs; # This is the main pkgs for Home Manager
  # specialArgs and extraSpecialArgs are not direct arguments to homeManagerConfiguration.
  # They must be passed via _module.args in a module.
  modules = [
    {
      _module.args = {
        # These will be available as top-level arguments in your profile modules
        inherit unstable; # The unstable packages specific to the system
        inherit desktop; # The desktop environment string
        inherit inputs; # All flake inputs
        inherit cleanInputs; # Flake inputs without 'self'
      };
    }
  ] ++ profileModules; # Append the actual profile modules
}
