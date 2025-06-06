{ inputs, lib }:

{ username, system, pkgs }:

let
  cleanInputs = builtins.removeAttrs inputs [ "self" ];

in inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  specialArgs = { };
  extraSpecialArgs = { inherit cleanInputs; inputs = cleanInputs; };
  modules = [
    ../home/profiles/${username}
  ];
}
