{ inputs, lib }:

{ username, system, pkgs, unstable ? null, desktop ? null }:

let
  cleanInputs = builtins.removeAttrs inputs [ "self" ];

in inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  specialArgs = { desktop = desktop; };
  extraSpecialArgs = { inherit cleanInputs unstable; inputs = cleanInputs; };
  modules = [
    ../home/profiles/${username}
  ];
}
